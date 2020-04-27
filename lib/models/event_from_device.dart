import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:study_calendar/generated/l10n.dart';
import 'package:study_calendar/models/user_data.dart';
import 'package:study_calendar/shared/error.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/services.dart';

/// An event associated with a calendar
class EventFromDevice {
  String eventId;
  String calendarEventId;
  String title;
  String description;
  DateTime start;
  DateTime end;
  bool allDay;
  DateTime day;
  String calendarId;
  int daysToTest;
  int fromWhen;

  EventFromDevice(
      {this.fromWhen = -30,
      this.daysToTest = 90,
      this.calendarEventId,
      this.title,
      this.day,
      this.start,
      this.end,
      this.description,
      this.allDay = false,
      this.calendarId});

  @override
  String toString() {
    return "Title: $title - Id: $eventId - Start : $start - End $end - Description: $description";
  }

//create function takes the event date and separates between day of event, start time and end time
//_event shoulb be [eventDay:[{"eventId":eventId,"description":eventDesciption,"startTime":timeStart,"endTime":timeEnd}]]
  Future<List<Map>> retrieveCalendars() async {
    DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();

    try {
      List<Map> calendars = [];
      var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
      if (permissionsGranted.isSuccess && !permissionsGranted.data) {
        permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
        if (!permissionsGranted.isSuccess || !permissionsGranted.data) {
          return calendars;
        }
      }

      final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();

      if (calendarsResult.isSuccess && calendarsResult.data.isNotEmpty) {
        calendarsResult.data.forEach((doc) {
          if (doc.id != null) {
            calendars.add({"id": doc.id, "name": doc.name});
          }
        });
        return calendars;
      } else {
        calendars = [];
        return calendars;
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<EventFromDevice>> retrieveEventsFromDevice(
      UserData _userData) async {
    try {
      String calendarToUse = _userData.calendarToUse;
      DateTime today = new DateTime.now();
      Map tonightEvent = {
        "start": new DateTime(
            today.year, today.month, today.day, _userData.night, 0, 0, 0, 0),
        "end":
            new DateTime(today.year, today.month, today.day, 23, 59, 0, 0, 0),
      };
      Map tomorrowMorningEvent = {
        "start": new DateTime(
            today.year, today.month, today.day, _userData.night, 0, 0, 0, 0),
        "end": new DateTime(today.year, today.month, today.day,
                _userData.morning, 0, 0, 0, 0)
            .add(new Duration(days: 1)),
      };
      Map todayEvent = {
        "start":
            new DateTime(today.year, today.month, today.day, 0, 0, 0, 0, 0),
        "end": new DateTime(today.year, today.month, today.day, today.hour,
            today.minute, 0, 0, 0),
      };
      List<EventFromDevice> events = [];

      events.add(EventFromDevice(
          start: tonightEvent["start"],
          end: tonightEvent["end"],
          description: "tonightEvent",
          calendarEventId: "0",
          calendarId: "noId",
          allDay: false));
      events.add(EventFromDevice(
          start: tomorrowMorningEvent["start"],
          end: tomorrowMorningEvent["end"],
          description: "tomorrowMorningEvent",
          calendarEventId: "0",
          calendarId: "noId",
          allDay: false));
      events.add(EventFromDevice(
          start: todayEvent["start"],
          end: todayEvent["end"],
          description: "todayEvent",
          calendarEventId: "0",
          calendarId: "noId",
          allDay: false));
      if (calendarToUse.isNotEmpty) {
        DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();
        final start = DateTime.now().add(new Duration(days: fromWhen));
        final end = new DateTime.now().add(new Duration(days: daysToTest));
        final retrieveEventsParams =
            new RetrieveEventsParams(startDate: start, endDate: end);

        Result<UnmodifiableListView<Event>> response =
            await _deviceCalendarPlugin.retrieveEvents(
                calendarToUse, retrieveEventsParams);
        if (response.isSuccess && response.data.isNotEmpty) {
          response.data.forEach((event) {
            events.add(EventFromDevice(
                start: event.start,
                end: event.end,
                description: event.title,
                calendarEventId: event.eventId,
                calendarId: event.calendarId,
                allDay: event.allDay));
          });
        }

        return events;
      } else {
        print("no calendar info found");
        return events;
      }
    } on PlatformException catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> deleteCalendarEvent(String calendarId, String eventId) async {
    DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();
    final deleteResult =
        await _deviceCalendarPlugin.deleteEvent(calendarId, eventId);
    if (deleteResult.isSuccess && deleteResult.data) {
      print("delete from calendar success $eventId");
    }
  }

  Future<String> createDeviceEvent(String calendarId,
      Map<dynamic, dynamic> event, BuildContext context) async {
    print("creting device event $event");
    DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();

    final eventToCreate = new Event(calendarId);

    try {
      String text = "";
      final test = await Firestore.instance
          .collection("tests")
          .document(event["testId"])
          .get();

      if (event["sessionNumber"] != null) {
        text =
            "${S.of(context).studySession} nº ${event["sessionNumber"]} ${S.of(context).forWord} ${test["subject"]} ";
      } else {
        text = "${event["description"]} ${event["subject"]}";
      }

      if (test.exists) {
        eventToCreate.title = "$text";
        eventToCreate.end = event["end"];
        eventToCreate.start = event["start"];
        eventToCreate.attendees = [];

        final eventId =
            await _deviceCalendarPlugin.createOrUpdateEvent(eventToCreate);

        return eventId.data;
      } else {
        throw new Error("error when creating device event");
      }
    } catch (e) {
      throw new Error("error when creating device event $e");
    }
  }
}
