import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:study_calendar/models/session.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class SessionTile extends StatefulWidget {
  final Session session;

  SessionTile({this.session});

  @override
  _SessionTileState createState() => _SessionTileState();
}

class _SessionTileState extends State<SessionTile> {
  @override
  Widget build(BuildContext context) {
    final _session = this.widget.session;
    final _start = new DateFormat("MMMM, d h:mm").format(_session.start);
    final _end = new DateFormat("h:00 a").format(_session.end);
    return Padding(
      padding: EdgeInsets.only(top: 8),
      child: Card(
        color: Colors.grey.shade200,
        elevation: 10,
        margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
        child: Column(
          children: <Widget>[
            ListTile(
              dense: true,
              onTap: () => _launchCalendarOnEvent(_session.calendarEventId),
              title: Center(
                child: AutoSizeText(
                  "Session ${_session.sessionNumber} $_start - $_end",
                  maxLines: 1,
                  minFontSize: 15,
                ),
              ),
            ),
          ],
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
}
