import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:study_calendar/generated/l10n.dart';
import 'package:study_calendar/helpers/TimeAllocation.dart';
import 'package:study_calendar/models/session.dart';
import 'package:study_calendar/models/test.dart';
import 'package:study_calendar/screens/home/session_tile.dart';
import 'package:study_calendar/services/database.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class TestTile extends StatefulWidget {
  final Test test;

  TestTile({this.test});

  @override
  _TestTileState createState() => _TestTileState();
}

class _TestTileState extends State<TestTile> {
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    final _parsedDueDate =
        new DateFormat("MMMM, d h:mm a").format(this.widget.test.dueDate);
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
                    tooltip: S.of(context).goToTest,
                    color: Colors.green.shade400,
                    icon: FaIcon(FontAwesomeIcons.solidArrowAltCircleRight),
                  ),
                  trailing: IconButton(
                    tooltip: S.of(context).deleteTest,
                    color: Colors.blueGrey,
                    onPressed: () async {
                      await _showConfirmDelete();
                    },
                    icon: FaIcon(
                      FontAwesomeIcons.trash,
                      color: Colors.red.shade200,
                    ),
                  ),
                  title: AutoSizeText(
                    "${this.widget.test.description} ${this.widget.test.subject}",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    maxLines: 1,
                  ),
                  subtitle: AutoSizeText(_tileText(_parsedDueDate, context),
                      maxLines: 1,
                      style: TextStyle(
                          color: Colors.black, fontStyle: FontStyle.italic)),
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

  String _tileText(String _parsedDueDate, BuildContext context) {
    String text;
    int daysToTest = TimeAllocation().daysUntil(widget.test.dueDate);

    if (daysToTest == 0 && widget.test.dueDate.day == DateTime.now().day) {
      text = "${S.of(context).dueToday}, $_parsedDueDate";
    } else if (daysToTest == 0 &&
        widget.test.dueDate.day != DateTime.now().day) {
      text = "${S.of(context).dueTomorrow}, $_parsedDueDate";
    } else if (daysToTest == 1) {
      text = "${S.of(context).dueTomorrow}, $_parsedDueDate";
    } else if (daysToTest < 0) {
      text = "${S.of(context).pastDue}, $_parsedDueDate";
    } else {
      text = "${S.of(context).dueInDays(daysToTest)}, $_parsedDueDate";
    }
    return text;
  }

  void _showTestDeletedToast(int numSessionsDeleted, BuildContext context) {
    String message = "";
    if (numSessionsDeleted == 0) {
      message = "${this.widget.test.subject} ${S.of(context).testRemoved}";
    } else if (numSessionsDeleted == 1) {
      message =
          "${this.widget.test.subject} ${S.of(context).testAndOneSession}";
    } else {
      message =
          "${this.widget.test.subject} ${S.of(context).testAndSessions(numSessionsDeleted)}";
    }

    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      textColor: Colors.black,
      fontSize: 15,
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
            S.of(context).deleteConfirm,
            textScaleFactor: 1,
            softWrap: true,
            style: TextStyle(fontWeight: FontWeight.normal),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[],
            ),
          ),
          actions: <Widget>[
            Visibility(
              visible: !_isDeleting,
              child: FlatButton(
                child: Text(S.of(context).delete,
                    style: TextStyle(color: Colors.red.shade400)),
                onPressed: () async {
                  if (!_isDeleting) {
                    print("inside, $_isDeleting");
                    setState(() {
                      _isDeleting = true;
                    });

                    final numSessionsDeleted = await DatabaseService()
                        .deleteTest(
                            this.widget.test.testId,
                            this.widget.test.calendarToUse,
                            this.widget.test.calendarEventId);

                    _showTestDeletedToast(numSessionsDeleted, context);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
            Visibility(
              visible: !_isDeleting,
              child: FlatButton(
                child: Text(S.of(context).cancel.toUpperCase()),
                onPressed: () {
                  if (!_isDeleting) {
                    Navigator.of(context).pop();
                  }
                },
              ),
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
    final _originalSessions = Provider.of<List<Session>>(context);

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        child: ListView.builder(
            itemCount:
                _originalSessions == null ? 0 : _originalSessions?.length,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              return SessionTile(session: _originalSessions[index] ?? "");
            }),
      ),
    );
  }
}
