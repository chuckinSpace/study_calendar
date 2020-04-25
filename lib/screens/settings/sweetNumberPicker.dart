import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:study_calendar/generated/l10n.dart';
import 'package:study_calendar/models/user_data.dart';

class SweetNumberPicker extends StatefulWidget {
  @override
  _SweetNumberPickerState createState() => _SweetNumberPickerState();
}

class _SweetNumberPickerState extends State<SweetNumberPicker> {
  int _sweetStart;
  int _sweetEnd;
  UserData _userData;
  didChangeDependencies() async {
    print("did fired");
    super.didChangeDependencies();
    _userData = Provider.of<UserData>(context);
    _sweetStart = _userData.sweetSpotStart;
    _sweetEnd = _userData.sweetSpotEnd;
  }

  bool _sweetEdit = false;

  @override
  Widget build(BuildContext context) {
    final _userData = Provider.of<UserData>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                S.of(context).start,
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
              new NumberPicker.integer(
                  listViewWidth: 60,
                  initialValue: _sweetStart,
                  minValue: 1,
                  maxValue: 22,
                  onChanged: (value) {
                    if (!_sweetEdit) {
                      setState(() {
                        _sweetEdit = true;
                      });
                    }
                    setState(() {
                      _sweetStart = value;
                    });
                    print("seetstart $_sweetStart");
                  }),
              Text(
                "HRS",
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                height: 100,
                child: VerticalDivider(
                  color: Colors.white60,
                  width: 1.0,
                  thickness: 1.0,
                ),
              ),
              Text(
                S.of(context).end,
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
              new NumberPicker.integer(
                  listViewWidth: 60,
                  initialValue: _sweetEnd,
                  minValue: _sweetStart,
                  maxValue: 23,
                  onChanged: (value) {
                    if (!_sweetEdit) {
                      setState(() {
                        _sweetEdit = true;
                      });
                    }
                    setState(() {
                      _sweetEnd = value;
                    });
                  }),
              Text(
                "HRS",
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
            ],
          ),
          Visibility(
            visible: _sweetEdit,
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              FlatButton(
                color: Colors.green.shade200,
                child: Text("SAVE"),
                onPressed: () async {
                  await _setSweetSpot(_sweetStart, _sweetEnd, _userData.uid);
                  setState(() {
                    _sweetEdit = false;
                  });
                },
              ),
            ]),
          )
        ],
      ),
    );
  }

  Future<void> _setSweetSpot(
      int newSweetStart, int newSweetEnd, String uid) async {
    print("sending start: $newSweetStart end: $newSweetEnd");
    return await Firestore.instance
        .collection("users")
        .document(uid)
        .updateData(
            {"sweetSpotStart": newSweetStart, "sweetSpotEnd": newSweetEnd});
  }
}
