/*
 * Copyright 2020 ZUP IT SERVICOS EM TECNOLOGIA E INOVACAO SA
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package br.com.zup.beagle.automatedTests.cucumber.steps

import androidx.test.rule.ActivityTestRule
import br.com.zup.beagle.automatedTests.activity.MainActivity
import br.com.zup.beagle.automatedTests.cucumber.robots.ScreenRobot
import br.com.zup.beagle.automatedTests.utils.ActivityFinisher
import br.com.zup.beagle.automatedTests.utils.TestUtils
import cucumber.api.java.After
import cucumber.api.java.Before
import cucumber.api.java.en.Given
import cucumber.api.java.en.Then
import cucumber.api.java.en.When
import org.junit.Rule

const val CONFIRM_BFF_URL = "http://10.0.2.2:8080/confirm"

class ConfirmScreenSteps {

    @Rule
    var activityTestRule = ActivityTestRule(MainActivity::class.java)

    @Before("@confirm")
    fun setup() {
        TestUtils.startActivity(activityTestRule, CONFIRM_BFF_URL)
    }

    @After("@confirm")
    fun tearDown() {
        ActivityFinisher.finishOpenActivities()
    }

    @Given("^the Beagle application did launch with the confirm screen url$")
    fun checkBaseScreen() {
        ScreenRobot()
            .checkViewContainsText("Confirm Screen", true)
    }

    @When("^I press a confirm button with the (.*) title$")
    fun clickOnButton(string:String) {
        ScreenRobot().clickOnText(string)
    }

    @Then("^a confirm with the (.*) message should appear on the screen$")
    fun checkConfirmMessage(string:String) {
        ScreenRobot()
            .checkViewContainsText(string, true)
    }

    @Then("^a confirm with the (.*) and (.*) should appear on the screen$")
    fun checkConfirmMessageAndTitle(string:String, string2:String) {
        ScreenRobot()
            .checkViewContainsText(string, true)
            .checkViewContainsText(string2, true)
    }

    @Then("^I press the confirmation (.*) button on the confirm component$")
    fun clickOnTheConfirmationActionButtonWithText(string:String){
        ScreenRobot().clickOnText(string)
    }

    @Then("^a confirm with a button with (.*) label should appear$")
    fun checkConfirmationButtonLabelIsSetWithText(string:String){
        ScreenRobot()
            .checkViewContainsText(string)
    }
}