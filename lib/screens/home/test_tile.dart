import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:study_calendar/helpers/TimeAllocation.dart';
import 'package:study_calendar/models/session.dart';
import 'package:study_calendar/models/test.dart';
import 'package:study_calendar/models/user_data.dart';
import 'package:study_calendar/screens/home/session_tile.dart';
import 'package:study_calendar/services/database.dart';
import 'package:url_launcher/url_launcher.dart';

class TestTile extends StatefulWidget {
  final Test test;

  TestTile({this.test});

  @override
  _TestTileState createState() => _TestTileState();
}

class _TestTileState extends State<TestTile> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<List<Session>>.value(
          value: DatabaseService().streamSessions(this.widget.test.testId),
        ),
      ],
      child: Padding(
        padding: EdgeInsets.only(top: 8),
        child: Card(
          elevation: 8,
          margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ExpansionTile(
                  children: <Widget>[Sessions()],
                  leading: IconButton(
                    onPressed: () => _launchCalendarOnEvent(
                        this.widget.test.calendarEventId),
                    tooltip: "Sessions Added To Calendar",
                    color: Colors.blueGrey,
                    icon: Icon(Icons.event_available),
                  ),
                  trailing: IconButton(
                    tooltip: "Delete test",
                    color: Colors.blueGrey,
                    onPressed: () {
                      _showConfirmDelete();
                    },
                    icon: FaIcon(
                      FontAwesomeIcons.trash,
                      color: Colors.red.shade200,
                    ),
                  ),
                  title: AutoSizeText(
                    "${this.widget.test.description} ${this.widget.test.subject}",
                    style: TextStyle(color: Colors.black),
                    maxLines: 1,
                  ),
                  subtitle:
                      Text(_tileText(), style: TextStyle(color: Colors.black)),
                ),
              ]),
        ),
      ),
    );
  }

  void _launchCalendarOnEvent(String eventId) async {
    try {
      var url = "content://com.android.calendar/events/$eventId";
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print(e);
    }
  }

  String _tileText() {
    String text;
    int daysToTest = TimeAllocation().daysUntil(widget.test.dueDate);

    if (daysToTest == 0) {
      text = "Due Today!";
    } else if (daysToTest == 1) {
      text = "Due Tomorrow!";
    } else if (daysToTest < 0) {
      text = "Past Due";
    } else {
      text = "Due in $daysToTest days";
    }
    return text;
  }

  void _showTestDeletedToast() {
    Fluttertoast.showToast(
      msg:
          "${this.widget.test.subject}  test and ${this.widget.test.complexity} sessions were Removed from your calendar",
      toastLength: Toast.LENGTH_LONG,
      textColor: Colors.black,
      fontSize: 20,
      backgroundColor: Colors.red.shade200,
      timeInSecForIosWeb: 5,
    );
  }

  Future<void> _showConfirmDelete() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              "This will delete This test and all sessions associated with it from your calendar, are you sure?"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                FlatButton(
                  child: Text('DELETE'),
                  onPressed: () async {
                    await DatabaseService().deleteTest(
                        this.widget.test.testId,
                        this.widget.test.calendarToUse,
                        this.widget.test.calendarEventId);
                    _showTestDeletedToast();
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class Sessions extends StatefulWidget {
  @override
  _SessionsState createState() => _SessionsState();
}

class _SessionsState extends State<Sessions> {
  @override
  Widget build(BuildContext context) {
    final _sessions = Provider.of<List<Session>>(context);

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        child: ListView.builder(
            itemCount: _sessions == null ? 0 : _sessions?.length,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              return SessionTile(session: _sessions[index] ?? "");
            }),
      ),
    );
  }
}
