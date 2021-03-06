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

import 'package:beagle/setup/beagle_design_system.dart';
import 'package:beagle_components/beagle_image.dart';
import 'package:beagle_components/beagle_tab_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockDesignSystem extends Mock implements DesignSystem {}

void main() {
  final designSystemMock = MockDesignSystem();
  when(designSystemMock.image(any)).thenReturn('images/beagle.png');

  const tabBarKey = Key('BeagleTabBar');
  final tabBarItems = <TabBarItem>[
    TabBarItem('Tab 1', LocalImagePath('')),
    TabBarItem('Tab 2', LocalImagePath('')),
    TabBarItem('Tab 3', LocalImagePath('')),
  ];

  Widget createWidget({
    Key key = tabBarKey,
    DesignSystem designSystem,
    List<TabBarItem> items = const [],
    int currentTab = 0,
    Function onTabSelection,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: BeagleTabBar(
          key: tabBarKey,
          designSystem: designSystem,
          items: items,
          currentTab: currentTab,
          onTabSelection: onTabSelection,
        ),
      ),
    );
  }

  TestWidgetsFlutterBinding.ensureInitialized();

  group('Given a BeagleTabBar', () {
    group('When the platform is android', () {
      testWidgets('Then it should have a TabBar child',
          (WidgetTester tester) async {
        await tester.pumpWidget(createWidget());

        final tabBarFinder = find.byType(TabBar);

        expect(tabBarFinder, findsOneWidget);
      });

      testWidgets('Then it should have the correct number of Tabs',
          (WidgetTester tester) async {
        await tester.pumpWidget(createWidget(items: tabBarItems));

        final tabFinder = find.byType(Tab);

        expect(tabFinder, findsNWidgets(tabBarItems.length));
      });
    });

    group('When the platform is iOS', () {
      testWidgets('Then it should have a CupertinoTabBar child',
          (WidgetTester tester) async {
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
        await tester.pumpWidget(createWidget(
          designSystem: designSystemMock,
          items: tabBarItems,
        ));

        final tabBarFinder = find.byType(CupertinoTabBar);

        expect(tabBarFinder, findsOneWidget);
        debugDefaultTargetPlatformOverride = null;
      });

      testWidgets('Then it should have correct number of tabs',
          (WidgetTester tester) async {
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
        await tester.pumpWidget(
            createWidget(designSystem: designSystemMock, items: tabBarItems));

        // CupertinoTabBar does not have a specific Widget to define a tab item
        // so, we are checking for the quantity of Text widgets
        final textFinder = find.byType(Text);

        expect(textFinder, findsNWidgets(tabBarItems.length));

        debugDefaultTargetPlatformOverride = null;
      });
    });

    group('When it has tabs', () {
      testWidgets('Then it should show correct tabs text',
          (WidgetTester tester) async {
        await tester.pumpWidget(createWidget(items: tabBarItems));

        final textFinderTab1 = find.text('Tab 1');
        expect(textFinderTab1, findsOneWidget);
        final textFinderTab2 = find.text('Tab 2');
        expect(textFinderTab2, findsOneWidget);
        final textFinderTab3 = find.text('Tab 3');
        expect(textFinderTab3, findsOneWidget);
      });
    });

    group('When a tab is tapped', () {
      testWidgets('Then it should call onTabSelection callback',
          (WidgetTester tester) async {
        final log = <int>[];
        void onTabSelection(Map<String, dynamic> map) {
          log.add(0);
        }

        await tester.pumpWidget(createWidget(
          items: tabBarItems,
          onTabSelection: onTabSelection,
        ));

        final textFinderTab1 = find.text('Tab 1');
        await tester.tap(textFinderTab1);
        await tester.pump();
        expect(log.length, 1);

        final textFinderTab2 = find.text('Tab 2');
        await tester.tap(textFinderTab2);
        await tester.pump();
        expect(log.length, 2);

        final textFinderTab3 = find.text('Tab 3');
        await tester.tap(textFinderTab3);
        await tester.pump();
        expect(log.length, 3);

        await tester.tap(textFinderTab1);
        await tester.pump();
        expect(log.length, 4);
      });

      testWidgets('Then it should update currentTab',
          (WidgetTester tester) async {
        var currentTab = -1;
        void onTabSelection(Map<String, dynamic> map) {
          currentTab = map['value'];
        }

        final widget = createWidget(
          items: tabBarItems,
          onTabSelection: onTabSelection,
        );

        await tester.pumpWidget(widget);

        final textFinderTab1 = find.text('Tab 1');
        await tester.tap(textFinderTab1);
        await tester.pump();
        expect(currentTab, 0);

        final textFinderTab2 = find.text('Tab 2');
        await tester.tap(textFinderTab2);
        await tester.pumpAndSettle();
        expect(currentTab, 1);

        final textFinderTab3 = find.text('Tab 3');
        await tester.tap(textFinderTab3);
        await tester.pump();
        expect(currentTab, 2);

        await tester.tap(textFinderTab1);
        await tester.pump();
        expect(currentTab, 0);
      });
    });
  });
}
