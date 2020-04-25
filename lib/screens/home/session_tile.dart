import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:study_calendar/generated/l10n.dart';
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
        color: Colors.grey.shade100,
        elevation: 10,
        margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
        child: Column(
          children: <Widget>[
            ListTile(
              leading: SizedBox(
                width: 10.0,
                child: FaIcon(
                  FontAwesomeIcons.calendarDay,
                  size: 25,
                  color: Colors.teal.shade400,
                ),
              ),
              trailing: IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.chevronRight,
                  size: 15,
                ),
                onPressed: () =>
                    _launchCalendarOnEvent(_session.calendarEventId),
              ),
              dense: true,
              subtitle: AutoSizeText(
                "$_start - $_end",
                minFontSize: 13,
              ),
              title: AutoSizeText(
                "${S.of(context).session} ${_session.sessionNumber}",
                minFontSize: 15,
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
