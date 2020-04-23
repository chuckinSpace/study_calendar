import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:study_calendar/models/event_from_device.dart';
import 'package:study_calendar/models/session.dart';
import 'package:study_calendar/models/test.dart';
import 'package:study_calendar/models/user_data.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  final CollectionReference userCollection =
      Firestore.instance.collection("users");
  final CollectionReference testCollection =
      Firestore.instance.collection("tests");
  final CollectionReference sessionsCollection =
      Firestore.instance.collection("sessions");

  Future createUserDocument(String email, String uid) async {
    EventFromDevice _device = EventFromDevice();
    try {
      final user = await userCollection.document(uid).get();
      if (user.exists == false) {
        await userCollection.document(uid).setData({
          "email": email,
          "isConfigured": false,
          "morning": 7,
          "night": 23,
          "nightOwl": true,
          "sweetSpotStart": 18,
          "sweetSpotEnd": 23,
          "calendarToUse": "",
          "calendarToUseName": "",
          "isWelcomeScreenSeen": false,
          "deviceCalendars": []
        });
        final calendars = await _device.retrieveCalendars();

        await userCollection.document(uid).updateData({
          "deviceCalendars": calendars,
        });

        print(calendars);
      }
    } catch (e) {
      print("error creting new user document $e");
    }
  }

  List<Test> _testListFromSnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.documents.map((doc) {
        return Test(
            subject: doc.data["subject"] ?? "",
            complexity: doc.data["complexity"] ?? 0,
            importance: doc.data["importance"] ?? 0,
            description: doc.data["description"] ?? "",
            dueDate: doc.data["dueDate"].toDate() ?? "",
            testId: doc.documentID,
            calendarEventId: doc.data["calendarEventId"] ?? "",
            calendarToUse: doc.data["calendarToUse"] ?? "",
            start: doc.data["start"].toDate() ?? "",
            end: doc.data["end"].toDate() ?? "");
      }).toList();
    } catch (e) {
      print("error on _tests from snapshot $e");
      return [];
    }
  }

  Future<String> createNewTest(
    String subject,
    int complexity,
    int importance,
    String description,
    DateTime dueDate,
    UserData _userData,
  ) async {
    print("uid on create test $uid");
    EventFromDevice eventFromDevice = EventFromDevice();
    try {
      final test = {
        "complexity": complexity,
        "subject": subject,
        "user": _userData.uid,
        "importance": importance,
        "description": description,
        "dueDate": dueDate,
        "start": dueDate,
        "end": dueDate.add(new Duration(hours: 2)),
        "calendarToUse": _userData.calendarToUse,
        "email": _userData.email
      };
      // add test
      final testCreated = await testCollection.add(test);
      print("testCreated $testCreated");
      //add testId as property on the test itself
      final testSnap =
          await testCollection.document(testCreated.documentID).get();

      final backTest = testSnap.data;

      final testForDevice = {
        "complexity": backTest["complexity"],
        "subject": backTest["subject"],
        "user": backTest["user"],
        "importance": backTest["importance"],
        "description": backTest["description"],
        "dueDate": backTest["dueDate"].toDate(),
        "start": backTest["dueDate"].toDate(),
        "end": backTest["end"].toDate(),
        "testId": testSnap.documentID
      };
      final calendarEventId = await eventFromDevice.createDeviceEvent(
          _userData.calendarToUse, testForDevice);
      if (testCreated != null) {
        await testCollection
            .document(testCreated.documentID)
            .updateData({"calendarEventId": calendarEventId});
      }
      return testCreated.documentID;
    } catch (e) {
      print("error on create New test $e");
      return "";
    }
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    try {
      return snapshot.exists
          ? UserData(
              uid: snapshot?.documentID,
              isConfigured: snapshot?.data["isConfigured"] ?? false,
              email: snapshot?.data["email"] ?? "",
              morning: snapshot?.data["morning"] ?? 7,
              night: snapshot?.data["night"] ?? 23,
              nightOwl: snapshot?.data["nightOwl"] ?? true,
              sweetSpotEnd: snapshot?.data["sweetSpotEnd"] ?? 22,
              sweetSpotStart: snapshot?.data["sweetSpotStart"] ?? 18,
              calendarToUse: snapshot?.data["calendarToUse"] ?? "",
              calendarToUseName: snapshot?.data["calendarToUseName"] ?? "",
              isWelcomeScreenSeen:
                  snapshot?.data["isWelcomeScreenSeen"] ?? false,
              deviceCalendars: snapshot?.data["deviceCalendars"] ?? [],
              isLoading: false)
          : UserData(isLoading: true);
    } catch (e) {
      print("error on userData snap $e");
      return null;
    }
  }

  List<Session> _sessionsDataFromSnapshot(QuerySnapshot snapshot) {
    try {
      if (snapshot.documents != null) {
        return snapshot.documents.map((doc) {
          return Session(
            email: doc?.data["email"],
            testId: doc?.data["testId"],
            sessionNumber: doc?.data["sessionNumber"],
            start: doc?.data["start"].toDate(),
            end: doc?.data["end"].toDate(),
            description: doc?.data["description"],
            calendarEventId: doc?.data["calendarEventId"],
            uid: doc?.documentID,
          );
        }).toList();
      } else {
        return [];
      }
    } catch (e) {
      print("error on sessions snap $e");
      return [];
    }
  }

  Future deleteTest(
      String testId, String calendarToUse, String calendarEventId) async {
    try {
      deleteSessions(testId, calendarToUse);
      await testCollection.document(testId).delete();
      EventFromDevice().deleteCalendarEvent(calendarToUse, calendarEventId);
    } catch (e) {
      print("error deleting $e");
    }
  }

  Future deleteSessions(String testId, String calendarToUse) async {
    await deleteDeviceEvents(testId);
    await deleteDocumentWhere("sessions", "testId", testId);
  }

  Future deleteDocumentWhere(
      String collection, String whereParam, String isEqualToParam) async {
    try {
      print("in delete document where");
      final results = await Firestore.instance
          .collection(collection)
          .where(whereParam, isEqualTo: isEqualToParam)
          .getDocuments();

      results.documents.forEach((doc) async => await doc.reference.delete());
    } catch (e) {
      print("error deleting $e");
    }
  }

  Future<void> deleteDeviceEvents(String testId) async {
    EventFromDevice eventFromDevice = EventFromDevice();
    try {
      final result = await Firestore.instance
          .collection("sessions")
          .where("testId", isEqualTo: testId)
          .getDocuments();

      if (result.documents.isNotEmpty) {
        result.documents.forEach((doc) async {
          //call delete device event with doc.calendarEventId
          await eventFromDevice.deleteCalendarEvent(
              doc.data["calendarToUse"], doc.data["calendarEventId"]);
        });
      } else {
        print("no calendar ids found");
      }
    } catch (e) {
      print("error when deleting from device");
    }
  }

  Future updateDocument(
      String collection, String docId, Map<String, dynamic> obj) async {
    try {
      print(" $collection,$docId,$obj");
      await Firestore.instance
          .collection(collection)
          .document(docId)
          .updateData(obj);
      print("in update");
    } catch (e) {
      print(e);
    }
  }

  Future createSessions(
    UserData _userData,
    String testId,
    int sessionNumber,
    DateTime start,
    DateTime end,
  ) async {
    EventFromDevice eventFromDevice = EventFromDevice();
    try {
      final event = {
        "testId": testId,
        "sessionNumber": sessionNumber,
        "uid": _userData.uid,
        "start": start,
        "end": end,
        "calendarToUse": _userData.calendarToUse,
        "email": _userData.email
      };

      final response = await sessionsCollection.add(event);
      final calendarEventId = await eventFromDevice.createDeviceEvent(
          _userData.calendarToUse, event);

      if (response != null) {
        await sessionsCollection
            .document(response.documentID)
            .updateData({"calendarEventId": calendarEventId});
      }
    } catch (e) {
      print(e);
    }
  }

  /*  Future<void> deleteDeviceTests(testId) async {
    EventFromDevice eventFromDevice = EventFromDevice();
    try {
      final result =
          await Firestore.instance.collection("tests").document(testId).get();

      if (result.exists) {
        //call delete device event with doc.calendarEventId
        eventFromDevice.deleteCalendarEvent(
            result.data["calendarToUse"], result.data["calendarEventId"]);
      } else {
        print("no calendar ids found");
      }
    } catch (e) {
      print("error when deleting from device");
    }
  }  */

  Stream<List<Session>> streamSessions(String testId) {
    return sessionsCollection
        .where("testId", isEqualTo: testId)
        .orderBy("sessionNumber", descending: false)
        .snapshots()
        .map(_sessionsDataFromSnapshot);
  }

  Stream<List<Test>> streamTests(String uid) {
    return testCollection
        .where("user", isEqualTo: uid)
        .orderBy("dueDate", descending: false)
        .snapshots()
        .map(_testListFromSnapshot);
  }

  Stream<UserData> streamUserData(String uid) {
    return userCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }
}