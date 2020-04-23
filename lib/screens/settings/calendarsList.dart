import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:study_calendar/models/user_data.dart';
import 'package:study_calendar/services/database.dart';

class CalendarList extends StatefulWidget {
  @override
  _CalendarListState createState() => _CalendarListState();
}

class _CalendarListState extends State<CalendarList> {
  @override
  Widget build(BuildContext context) {
    final _userData = Provider.of<UserData>(context);
    final _calendars = _userData.deviceCalendars;

    print(_calendars);
    return Container(
      child: ListView.builder(
          itemCount: _calendars == null ? 0 : _calendars?.length,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemBuilder: (context, index) {
            return ListTile(
                onTap: () async {
                  await DatabaseService()
                      .updateDocument("users", _userData.uid, {
                    "calendarToUse": _calendars[index]["id"],
                    "calendarToUseName": _calendars[index]["name"]
                  });
                },
                trailing: _calendars[index]["id"] == _userData.calendarToUse
                    ? FaIcon(
                        FontAwesomeIcons.check,
                        color: Colors.white,
                      )
                    : new Container(width: 0, height: 0),
                title: Text(
                  _calendars[index]["name"],
                  style: TextStyle(color: Colors.white),
                ));
          }),
    );
  }
}
