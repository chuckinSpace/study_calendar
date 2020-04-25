// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

class S {
  S();
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final String name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return S();
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  String get tutorial {
    return Intl.message(
      'Show Tutorial',
      name: 'tutorial',
      desc: '',
      args: [],
    );
  }

  String get addTest {
    return Intl.message(
      'Add Test',
      name: 'addTest',
      desc: '',
      args: [],
    );
  }

  String get goToCalendar {
    return Intl.message(
      'Go To Calendar',
      name: 'goToCalendar',
      desc: '',
      args: [],
    );
  }

  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  String get goToCalendarTut {
    return Intl.message(
      'This open your device\'s Calendar, where you can check or modify your created sessions and tests, also set reminders if you want',
      name: 'goToCalendarTut',
      desc: '',
      args: [],
    );
  }

  String get addTestTut {
    return Intl.message(
      'Add a new test, It will be added to your device\'s Calendar, along with the corresponding study sessions',
      name: 'addTestTut',
      desc: '',
      args: [],
    );
  }

  String get settingsTut {
    return Intl.message(
      'Use your settings to define what Calendar we should use to write and read events, set you best times to study, cut offs and more',
      name: 'settingsTut',
      desc: '',
      args: [],
    );
  }

  String get settingsWarning {
    return Intl.message(
      'Before we Start please select what Calendar we should use',
      name: 'settingsWarning',
      desc: '',
      args: [],
    );
  }

  String get done {
    return Intl.message(
      'DONE',
      name: 'done',
      desc: '',
      args: [],
    );
  }

  String get option {
    return Intl.message(
      'description',
      name: 'option',
      desc: '',
      args: [],
    );
  }

  String get calendarToUse {
    return Intl.message(
      'Calendar to use',
      name: 'calendarToUse',
      desc: '',
      args: [],
    );
  }

  String get selectACalendar {
    return Intl.message(
      'SELECT A CALENDAR',
      name: 'selectACalendar',
      desc: '',
      args: [],
    );
  }

  String get sweetSpot {
    return Intl.message(
      'Sweet spot',
      name: 'sweetSpot',
      desc: '',
      args: [],
    );
  }

  String get cutOff {
    return Intl.message(
      'Cut Off',
      name: 'cutOff',
      desc: '',
      args: [],
    );
  }

  String get nightOwl {
    return Intl.message(
      'Night Owl',
      name: 'nightOwl',
      desc: '',
      args: [],
    );
  }

  String get logOut {
    return Intl.message(
      'Log Out',
      name: 'logOut',
      desc: '',
      args: [],
    );
  }

  String get calendars {
    return Intl.message(
      'Calendars',
      name: 'calendars',
      desc: '',
      args: [],
    );
  }

  String get calendarsTut {
    return Intl.message(
      'Select which calendar to use. \nStudy Calendar will retrieve events from this calendar to check for availability,it will also write the tests and sessions created.',
      name: 'calendarsTut',
      desc: '',
      args: [],
    );
  }

  String get sweetSpotTut {
    return Intl.message(
      'Study Calendar will always try to allocate sessions between these times first.',
      name: 'sweetSpotTut',
      desc: '',
      args: [],
    );
  }

  String get cutOffTut {
    return Intl.message(
      'These are the times you do not want to study, usually used for bed time.\nHint: \nYou can use the morning cut off to take your classes into account!\nExample: Your classes end every day around 4pm, set the morning cut off to 4pm.',
      name: 'cutOffTut',
      desc: '',
      args: [],
    );
  }

  String get nightOwlTut {
    return Intl.message(
      'If your sweet spot times are busy, Study Calendar will try later that day if this option is selected. Otherwise it will try earlier that day.',
      name: 'nightOwlTut',
      desc: '',
      args: [],
    );
  }

  String get morning {
    return Intl.message(
      'MORNING',
      name: 'morning',
      desc: '',
      args: [],
    );
  }

  String get night {
    return Intl.message(
      'NIGHT',
      name: 'night',
      desc: '',
      args: [],
    );
  }

  String get start {
    return Intl.message(
      'START',
      name: 'start',
      desc: '',
      args: [],
    );
  }

  String get end {
    return Intl.message(
      'END',
      name: 'end',
      desc: '',
      args: [],
    );
  }

  String get courseCode {
    return Intl.message(
      'Course Code',
      name: 'courseCode',
      desc: '',
      args: [],
    );
  }

  String get enterSubject {
    return Intl.message(
      'Please enter subject',
      name: 'enterSubject',
      desc: '',
      args: [],
    );
  }

  String get description {
    return Intl.message(
      'Description',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  String get enterDescription {
    return Intl.message(
      'Please enter description',
      name: 'enterDescription',
      desc: '',
      args: [],
    );
  }

  String get dueDate {
    return Intl.message(
      'Due Date',
      name: 'dueDate',
      desc: '',
      args: [],
    );
  }

  String get pickADate {
    return Intl.message(
      ' Pick a Date',
      name: 'pickADate',
      desc: '',
      args: [],
    );
  }

  String get testComplexity {
    return Intl.message(
      'Test Complexity',
      name: 'testComplexity',
      desc: '',
      args: [],
    );
  }

  String get whatIsThis {
    return Intl.message(
      'What is this?',
      name: 'whatIsThis',
      desc: '',
      args: [],
    );
  }

  String get testComplexityTut {
    return Intl.message(
      'The more complex the test, the more sessions we will try to create.\nThe final amount of session will depend on how close is the due date and how much time available you have on your calendar.\nThe maximum amount of sessions is 5.',
      name: 'testComplexityTut',
      desc: '',
      args: [],
    );
  }

  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  String get noTimeForSessions {
    return Intl.message(
      'The test is too soon,\nno session were created for this test',
      name: 'noTimeForSessions',
      desc: '',
      args: [],
    );
  }

  String get oneSessionCreated {
    return Intl.message(
      'Test And 1 new study session was added to your calendar',
      name: 'oneSessionCreated',
      desc: '',
      args: [],
    );
  }

  String get moreSessionsCreated {
    return Intl.message(
      'new study sessions were added to your calendar',
      name: 'moreSessionsCreated',
      desc: '',
      args: [],
    );
  }

  String get and {
    return Intl.message(
      'and',
      name: 'and',
      desc: '',
      args: [],
    );
  }

  String get endDateError {
    return Intl.message(
      'END must be after START',
      name: 'endDateError',
      desc: '',
      args: [],
    );
  }

  String get goToTest {
    return Intl.message(
      'Go To Test',
      name: 'goToTest',
      desc: '',
      args: [],
    );
  }

  String get deleteTest {
    return Intl.message(
      'Delete test',
      name: 'deleteTest',
      desc: '',
      args: [],
    );
  }

  String get dueToday {
    return Intl.message(
      'Due Today!',
      name: 'dueToday',
      desc: '',
      args: [],
    );
  }

  String get dueTomorrow {
    return Intl.message(
      'Due Tomorrow!',
      name: 'dueTomorrow',
      desc: '',
      args: [],
    );
  }

  String get pastDue {
    return Intl.message(
      'Past Due',
      name: 'pastDue',
      desc: '',
      args: [],
    );
  }

  String dueInDays(Object daysToTest) {
    return Intl.message(
      'Due in $daysToTest days',
      name: 'dueInDays',
      desc: '',
      args: [daysToTest],
    );
  }

  String get testRemoved {
    return Intl.message(
      'test was removed from your calendar',
      name: 'testRemoved',
      desc: '',
      args: [],
    );
  }

  String get testAndOneSession {
    return Intl.message(
      'test and 1 session was removed from your calendar',
      name: 'testAndOneSession',
      desc: '',
      args: [],
    );
  }

  String testAndSessions(Object numSessionsDeleted) {
    return Intl.message(
      'test and $numSessionsDeleted sessions were removed from your calendar',
      name: 'testAndSessions',
      desc: '',
      args: [numSessionsDeleted],
    );
  }

  String get deleteConfirm {
    return Intl.message(
      'This will delete this test and all sessions associated with it from your calendar, are you sure?',
      name: 'deleteConfirm',
      desc: '',
      args: [],
    );
  }

  String get delete {
    return Intl.message(
      'DELETE',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  String get session {
    return Intl.message(
      'Session',
      name: 'session',
      desc: '',
      args: [],
    );
  }

  String get recover {
    return Intl.message(
      'Password Recovery',
      name: 'recover',
      desc: '',
      args: [],
    );
  }

  String get enterEmail {
    return Intl.message(
      'Enter an email',
      name: 'enterEmail',
      desc: '',
      args: [],
    );
  }

  String get emailEmpty {
    return Intl.message(
      ' Email Can\'t Be Empty',
      name: 'emailEmpty',
      desc: '',
      args: [],
    );
  }

  String get recoverBig {
    return Intl.message(
      'RECOVER',
      name: 'recoverBig',
      desc: '',
      args: [],
    );
  }

  String get emailSent {
    return Intl.message(
      'Email Sent Correctly',
      name: 'emailSent',
      desc: '',
      args: [],
    );
  }

  String get backLogin {
    return Intl.message(
      'BACK TO LOGIN',
      name: 'backLogin',
      desc: '',
      args: [],
    );
  }

  String get signUp {
    return Intl.message(
      'SignUp',
      name: 'signUp',
      desc: '',
      args: [],
    );
  }

  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  String get enterPassword {
    return Intl.message(
      'Enter Password',
      name: 'enterPassword',
      desc: '',
      args: [],
    );
  }

  String get password {
    return Intl.message(
      'PASSWORD',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  String get passwordEmpty {
    return Intl.message(
      'Password Can\'t Be Empty',
      name: 'passwordEmpty',
      desc: '',
      args: [],
    );
  }

  String get passNoMatch {
    return Intl.message(
      'Password do not match',
      name: 'passNoMatch',
      desc: '',
      args: [],
    );
  }

  String get repeatPass {
    return Intl.message(
      'REPEAT PASSWORD',
      name: 'repeatPass',
      desc: '',
      args: [],
    );
  }

  String get forgot {
    return Intl.message(
      'Forgot Your Password?',
      name: 'forgot',
      desc: '',
      args: [],
    );
  }

  String get createAccount {
    return Intl.message(
      'CREATE ACCOUNT',
      name: 'createAccount',
      desc: '',
      args: [],
    );
  }

  String get accessGoogle {
    return Intl.message(
      'ACCESS WITH GOOGLE',
      name: 'accessGoogle',
      desc: '',
      args: [],
    );
  }

  String get haveAccount {
    return Intl.message(
      'ALREADY HAVE AN ACCOUNT',
      name: 'haveAccount',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'es'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (Locale supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}