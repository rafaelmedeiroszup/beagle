#!/bin/bash

#
# Copyright 2020 ZUP IT SERVICOS EM TECNOLOGIA E INOVACAO SA
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

set -e

AVD_NAME='Pixel_3a_API_30_x86'
AVD_IMAGE='system-images;android-30;google_apis;x86'
APP_ANDROID_DIR=tests/appium/app-android
APP_ANDROID_APK_FILE=$GITHUB_WORKSPACE/$APP_ANDROID_DIR/app/build/outputs/apk/debug/app-debug.apk
AVD_CONFIG_FILE=~/.android/avd/$AVD_NAME.avd/config.ini

function checkFileExists(){
	if [ -f "$1" ]; then
		echo "file $1 exists!"
	else 
		echo "ERROR: file $1 not found!"
		exit 1
	fi
}

# trap exit SIGHUP SIGINT


echo "##### Generating .apk from project $APP_ANDROID_DIR ..."
chmod +x $APP_ANDROID_DIR/gradlew
$APP_ANDROID_DIR/gradlew -p $APP_ANDROID_DIR assembleDebug
checkFileExists $APP_ANDROID_APK_FILE

echo "##### Installing / updating image $AVD_IMAGE ..."
"$ANDROID_HOME"/tools/bin/sdkmanager "$AVD_IMAGE"
"$ANDROID_HOME"/tools/bin/sdkmanager --update

#echo "##### Emulator version:"
$ANDROID_HOME/emulator/emulator -version

if "$ANDROID_HOME"/emulator/emulator -list-avds | grep -q "$AVD_NAME"; then
    echo "##### Using avd from cache"
else
    echo "##### AVD not found in cache, creating AVD ..."
    #blank line necessary as input to AVD
    echo n | "$ANDROID_HOME"/tools/bin/avdmanager create avd -f -n $AVD_NAME -k "$AVD_IMAGE"
fi

echo "##### Checking if AVD was created correctly ..."
checkFileExists $AVD_CONFIG_FILE

echo "##### Adding AVD properties ..."
echo "hw.lcd.density=440
hw.lcd.height=2220
hw.lcd.width=1080
hw.ramSize=1536
vm.heapSize = 512
hw.gpu.enabled = yes
hw.gpu.mode = auto" >> $AVD_CONFIG_FILE

#echo "##### Checking if a hypervisor is installed"
#"$ANDROID_HOME"/emulator/emulator -accel-check

echo "##### Starting emulator with AVD ..."
nohup "$ANDROID_HOME"/emulator/emulator -avd $AVD_NAME -no-window -no-snapshot -noaudio -no-boot-anim 2>&1 &


echo "##### Waiting for device to boot"
"$ANDROID_HOME"/platform-tools/adb wait-for-device shell <<ENDSCRIPT
echo "" > /data/local/tmp/zero
getprop dev.bootcomplete > /data/local/tmp/bootcomplete
while cmp /data/local/tmp/zero /data/local/tmp/bootcomplete; do
{
    echo -n "."
    sleep 1
    getprop dev.bootcomplete > /data/local/tmp/bootcomplete
}; done
echo "Booted."
exit
ENDSCRIPT

echo "#### Giving additional 15s for the device to finish booting and setting up  ..."
sleep 15

echo "##### Installing the .apk file in the emulator ..."
$ANDROID_HOME/platform-tools/adb install -r -t $APP_ANDROID_APK_FILE

echo "##### Waiting 30 secs for the app to be installed ..."
sleep 30

echo "##### Checking if the .apk was installed in the emulator ... "
OUTPUT=`$ANDROID_HOME/platform-tools/adb shell pm list packages`
if echo "$OUTPUT" | grep -q "package:br.com.zup.beagle.appiumapp"; then
    echo "OK!"
else 
	echo "ERROR: app not installed! (package not found: br.com.zup.beagle.appiumapp)"
	exit 1
fi

echo "##### AVD settings after he process: "
cat $AVD_CONFIG_FILE

