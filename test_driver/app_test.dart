// Imports the Flutter Driver API.
import 'package:path/path.dart';
import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';

import 'package:test/test.dart';

void main() {
  group('Login', () {
    // First, define the Finders and use them to locate widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys in step 1.
    final googleBtn = find.byValueKey('googleSignIn');
    final passField = find.byValueKey('passField');
    final emailField = find.byValueKey('emailField');
    final repeatField = find.byValueKey('repeatField');
    final myEmail = find.text("carlosmoyanor@gmail.com");
    final btnSignInorRegister = find.byValueKey("btnSignInorRegister");
    final addTest = find.byTooltip("Add Test");
    final btnHaveActNewAct = find.byValueKey("btnHaveActNewAct");
    /* final buttonFinder = find.byValueKey('increment'); */

    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      final adbPath = join(
        "/Users/carlosmoyano/Library/Android/sdk/",
        'platform-tools',
        'adb',
      );
      await Process.run(adbPath, [
        'shell',
        'pm',
        'grant',
        'com.study_time',
        'android.permission.READ_CALENDAR'
      ]);
      await Process.run(adbPath, [
        'shell',
        'pm',
        'grant',
        'com.study_time',
        'android.permission.WRITE_CALENDAR'
      ]);
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('check flutter driver health', () async {
      Health health = await driver.checkHealth();
      print(health.status);
    });

    test('login first time', () async {
      final pv = find.byValueKey('pageview');

      // Login on old account
      await driver.tap(emailField);
      await driver.enterText("testUser@test.com");
      await driver.tap(passField);
      await driver.enterText("24682468");
      await driver.tap(btnSignInorRegister);
      // Welcome screen (first time users)
      await driver.waitFor(pv);
      await driver.getText(find.text('Create'));
      await driver.scroll(pv, -400, 0, Duration(milliseconds: 500));
      await driver.getText(find.text('Calendar'));
      await driver.scroll(pv, -400, 0, Duration(milliseconds: 500));
      await driver.getText(find.text('Done!'));
      await Future<void>.delayed(Duration(seconds: 5));

      //Settings first time users
      final settingsPage = find.byValueKey('settingsPage');

      /*  final selectCalendarTile = find.text('SELECT A CALENDAR'); */

      await driver.waitFor(find.text("Sweet spot"));

      /*   await driver.tap(sweetSpotBtn); */

      /*  

      await driver.waitFor(find.byTooltip("Add Test")); */
    });
    /*  await driver.tap(find.byValueKey('inputKeyString'));
    await driver.enterText('Hello !');
    await driver.waitFor(find.text('Hello !'));
    await driver.enterText('World');
    await driver.waitForAbsent(find.text('Hello !')); */

    /* test('register', () async {
      // Use the `driver.getText` method to verify the counter starts at 0.

      await driver.tap(btnHaveActNewAct);
      await driver.tap(emailField);
      await driver.enterText("testUser@test.com");
      await driver.tap(passField);
      await driver.enterText("24682468");
      await driver.tap(repeatField);
      await driver.enterText("24682468");
      await driver.tap(btnSignInorRegister);
      
      await driver.waitFor(find.byTooltip("Add Test"));
    }); */
  });
}
