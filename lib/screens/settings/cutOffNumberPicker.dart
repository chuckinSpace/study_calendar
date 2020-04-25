import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:study_calendar/generated/l10n.dart';
import 'package:study_calendar/models/user_data.dart';

class CutOffNumberPicker extends StatefulWidget {
  @override
  _CutOffNumberPickerState createState() => _CutOffNumberPickerState();
}

class _CutOffNumberPickerState extends State<CutOffNumberPicker> {
  int _morning;
  int _night;
  UserData _userData;
  didChangeDependencies() async {
    print("did fired");
    super.didChangeDependencies();
    _userData = Provider.of<UserData>(context);
    _morning = _userData.morning;
    _night = _userData.night;
  }

  bool _cutEdit = false;

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
                S.of(context).morning,
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
              new NumberPicker.integer(
                  listViewWidth: 60,
                  initialValue: _morning,
                  minValue: 1,
                  maxValue: 22,
                  onChanged: (value) {
                    if (!_cutEdit) {
                      setState(() {
                        _cutEdit = true;
                      });
                    }
                    setState(() {
                      _morning = value;
                    });
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
                S.of(context).night,
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
              new NumberPicker.integer(
                  listViewWidth: 60,
                  initialValue: _night,
                  minValue: _morning,
                  maxValue: 23,
                  onChanged: (value) {
                    if (!_cutEdit) {
                      setState(() {
                        _cutEdit = true;
                      });
                    }
                    setState(() {
                      _night = value;
                    });
                  }),
              Text(
                "HRS",
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
            ],
          ),
          Visibility(
            visible: _cutEdit,
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              FlatButton(
                child: Text("SAVE"),
                color: Colors.green.shade200,
                onPressed: () async {
                  await _setCutOff(_morning, _night, _userData.uid);
                  setState(() {
                    _cutEdit = false;
                  });
                },
              ),
            ]),
          )
        ],
      ),
    );
  }

  Future<void> _setCutOff(int newMorning, int newNight, String uid) async {
    return await Firestore.instance
        .collection("users")
        .document(uid)
        .updateData({"morning": newMorning, "night": newNight});
  }
}
