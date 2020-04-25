// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static m0(daysToTest) => "Due in ${daysToTest} days";

  static m1(numSessionsDeleted) => "test and ${numSessionsDeleted} sessions were removed from your calendar";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "accessGoogle" : MessageLookupByLibrary.simpleMessage("ACCESS WITH GOOGLE"),
    "addTest" : MessageLookupByLibrary.simpleMessage("Add Test"),
    "addTestTut" : MessageLookupByLibrary.simpleMessage("Add a new test, It will be added to your device\'s Calendar, along with the corresponding study sessions"),
    "and" : MessageLookupByLibrary.simpleMessage("and"),
    "backLogin" : MessageLookupByLibrary.simpleMessage("BACK TO LOGIN"),
    "calendarToUse" : MessageLookupByLibrary.simpleMessage("Calendar to use"),
    "calendars" : MessageLookupByLibrary.simpleMessage("Calendars"),
    "calendarsTut" : MessageLookupByLibrary.simpleMessage("Select which calendar to use. \nStudy Calendar will retrieve events from this calendar to check for availability,it will also write the tests and sessions created."),
    "cancel" : MessageLookupByLibrary.simpleMessage("Cancel"),
    "courseCode" : MessageLookupByLibrary.simpleMessage("Course Code"),
    "createAccount" : MessageLookupByLibrary.simpleMessage("CREATE ACCOUNT"),
    "cutOff" : MessageLookupByLibrary.simpleMessage("Cut Off"),
    "cutOffTut" : MessageLookupByLibrary.simpleMessage("These are the times you do not want to study, usually used for bed time.\nHint: \nYou can use the morning cut off to take your classes into account!\nExample: Your classes end every day around 4pm, set the morning cut off to 4pm."),
    "delete" : MessageLookupByLibrary.simpleMessage("DELETE"),
    "deleteConfirm" : MessageLookupByLibrary.simpleMessage("This will delete this test and all sessions associated with it from your calendar, are you sure?"),
    "deleteTest" : MessageLookupByLibrary.simpleMessage("Delete test"),
    "description" : MessageLookupByLibrary.simpleMessage("Description"),
    "done" : MessageLookupByLibrary.simpleMessage("DONE"),
    "dueDate" : MessageLookupByLibrary.simpleMessage("Due Date"),
    "dueInDays" : m0,
    "dueToday" : MessageLookupByLibrary.simpleMessage("Due Today!"),
    "dueTomorrow" : MessageLookupByLibrary.simpleMessage("Due Tomorrow!"),
    "emailEmpty" : MessageLookupByLibrary.simpleMessage(" Email Can\'t Be Empty"),
    "emailSent" : MessageLookupByLibrary.simpleMessage("Email Sent Correctly"),
    "end" : MessageLookupByLibrary.simpleMessage("END"),
    "endDateError" : MessageLookupByLibrary.simpleMessage("END must be after START"),
    "enterDescription" : MessageLookupByLibrary.simpleMessage("Please enter description"),
    "enterEmail" : MessageLookupByLibrary.simpleMessage("Enter an email"),
    "enterPassword" : MessageLookupByLibrary.simpleMessage("Enter Password"),
    "enterSubject" : MessageLookupByLibrary.simpleMessage("Please enter subject"),
    "forgot" : MessageLookupByLibrary.simpleMessage("Forgot Your Password?"),
    "goToCalendar" : MessageLookupByLibrary.simpleMessage("Go To Calendar"),
    "goToCalendarTut" : MessageLookupByLibrary.simpleMessage("This open your device\'s Calendar, where you can check or modify your created sessions and tests, also set reminders if you want"),
    "goToTest" : MessageLookupByLibrary.simpleMessage("Go To Test"),
    "haveAccount" : MessageLookupByLibrary.simpleMessage("ALREADY HAVE AN ACCOUNT"),
    "logOut" : MessageLookupByLibrary.simpleMessage("Log Out"),
    "login" : MessageLookupByLibrary.simpleMessage("Login"),
    "moreSessionsCreated" : MessageLookupByLibrary.simpleMessage("new study sessions were added to your calendar"),
    "morning" : MessageLookupByLibrary.simpleMessage("MORNING"),
    "night" : MessageLookupByLibrary.simpleMessage("NIGHT"),
    "nightOwl" : MessageLookupByLibrary.simpleMessage("Night Owl"),
    "nightOwlTut" : MessageLookupByLibrary.simpleMessage("If your sweet spot times are busy, Study Calendar will try later that day if this option is selected. Otherwise it will try earlier that day."),
    "noTimeForSessions" : MessageLookupByLibrary.simpleMessage("The test is too soon,\nno session were created for this test"),
    "oneSessionCreated" : MessageLookupByLibrary.simpleMessage("Test And 1 new study session was added to your calendar"),
    "option" : MessageLookupByLibrary.simpleMessage("description"),
    "passNoMatch" : MessageLookupByLibrary.simpleMessage("Password do not match"),
    "password" : MessageLookupByLibrary.simpleMessage("PASSWORD"),
    "passwordEmpty" : MessageLookupByLibrary.simpleMessage("Password Can\'t Be Empty"),
    "pastDue" : MessageLookupByLibrary.simpleMessage("Past Due"),
    "pickADate" : MessageLookupByLibrary.simpleMessage(" Pick a Date"),
    "recover" : MessageLookupByLibrary.simpleMessage("Password Recovery"),
    "recoverBig" : MessageLookupByLibrary.simpleMessage("RECOVER"),
    "repeatPass" : MessageLookupByLibrary.simpleMessage("REPEAT PASSWORD"),
    "selectACalendar" : MessageLookupByLibrary.simpleMessage("SELECT A CALENDAR"),
    "session" : MessageLookupByLibrary.simpleMessage("Session"),
    "settings" : MessageLookupByLibrary.simpleMessage("Settings"),
    "settingsTut" : MessageLookupByLibrary.simpleMessage("Use your settings to define what Calendar we should use to write and read events, set you best times to study, cut offs and more"),
    "settingsWarning" : MessageLookupByLibrary.simpleMessage("Before we Start please select what Calendar we should use"),
    "signUp" : MessageLookupByLibrary.simpleMessage("SignUp"),
    "start" : MessageLookupByLibrary.simpleMessage("START"),
    "sweetSpot" : MessageLookupByLibrary.simpleMessage("Sweet spot"),
    "sweetSpotTut" : MessageLookupByLibrary.simpleMessage("Study Calendar will always try to allocate sessions between these times first."),
    "testAndOneSession" : MessageLookupByLibrary.simpleMessage("test and 1 session was removed from your calendar"),
    "testAndSessions" : m1,
    "testComplexity" : MessageLookupByLibrary.simpleMessage("Test Complexity"),
    "testComplexityTut" : MessageLookupByLibrary.simpleMessage("The more complex the test, the more sessions we will try to create.\nThe final amount of session will depend on how close is the due date and how much time available you have on your calendar.\nThe maximum amount of sessions is 5."),
    "testRemoved" : MessageLookupByLibrary.simpleMessage("test was removed from your calendar"),
    "tutorial" : MessageLookupByLibrary.simpleMessage("Show Tutorial"),
    "whatIsThis" : MessageLookupByLibrary.simpleMessage("What is this?")
  };
}
