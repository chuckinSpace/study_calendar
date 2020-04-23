import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:study_calendar/constants.dart';
import 'package:study_calendar/helpers/TimeAllocation.dart';
import 'package:study_calendar/models/user_data.dart';
import 'package:study_calendar/services/database.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter_rounded_date_picker/rounded_picker.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();

  String _currentSubject;
  int _currentComplexity = 1;
  int _currentImportance = 1;
  String _currentDescription = "";
  DateTime _currentDay = DateTime.now();
  TimeOfDay _currentStartTime = TimeOfDay.now();
  /*  TimeOfDay _currentFinishTime = TimeOfDay.now(); */
  DateTime _currentDueDate =
      DateTime.now().add(new Duration(days: 1)).add(new Duration(hours: 1));
  String _parsedDueDate = "";
  bool isLoading = false;

  Future<void> _showDateTimePicker(BuildContext context) async {
    DateTime daySelected = await showRoundedDatePicker(
      context: context,
      theme: ThemeData(primarySwatch: Colors.blue),
      description: "Test Due Date",
    );
    if (daySelected != null) {
      setState(() {
        _currentDay = daySelected;
      });
    }
    final startTimeSelected = await showRoundedTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (startTimeSelected != null) {
      setState(() {
        _currentStartTime = startTimeSelected;
      });
    }
    final endTimeSelected = await showRoundedTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (endTimeSelected != null) {
      /*   setState(() {
        _currentFinishTime = endTimeSelected;
      });
 */
      setState(() {
        _currentDueDate = new DateTime(
            _currentDay.year,
            _currentDay.month,
            _currentDay.day,
            _currentStartTime.hour,
            _currentStartTime.minute,
            0,
            0);

        _parsedDueDate = new DateFormat("MMMM,EEEE d hh:mm aaa").format(
            DateTime(_currentDay.year, _currentDay.month, _currentDay.day,
                _currentStartTime.hour, _currentStartTime.minute, 0, 0));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final _userData = Provider.of<UserData>(context);

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: isLoading
            ? Container(
                child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: SpinKitFoldingCube(
                    color: Theme.of(context).primaryColor, size: 150),
              ))
            : Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Flexible(
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          decoration: textInputDecoration.copyWith(
                              hintText: "Course Code"),
                          validator: (val) =>
                              val.isEmpty ? "Please enter subject" : null,
                          onChanged: (val) =>
                              setState(() => _currentSubject = val),
                        ),
                      ),
                      SizedBox(width: 5),
                      new Flexible(
                        child: TextFormField(
                          decoration: textInputDecoration.copyWith(
                              hintText: "Description"),
                          validator: (val) =>
                              val.isEmpty ? "Please enter description" : null,
                          onChanged: (val) {
                            setState(() => _currentDescription = val);
                          },
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      FloatingActionButton(
                        heroTag: "test calendar",
                        onPressed: () async {
                          await _showDateTimePicker(context);
                        },
                        tooltip: 'Due Date',
                        child: Icon(Icons.calendar_today),
                        foregroundColor: Colors.black,
                        backgroundColor: _parsedDueDate == ""
                            ? Theme.of(context).accentColor
                            : Theme.of(context).buttonColor,
                        elevation: 0,
                      ),
                      SizedBox(width: 10),
                      AutoSizeText(
                        "Due Date :",
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                      Wrap(
                        children: [
                          AutoSizeText(
                            _parsedDueDate == ""
                                ? " Pick a Date"
                                : " $_parsedDueDate",
                            style: TextStyle(
                              color: _parsedDueDate == ""
                                  ? Colors.red
                                  : Colors.black,
                            ),
                            maxLines: 1,
                            maxFontSize: 12,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  AutoSizeText("Test Complexity"),
                  Slider(
                    label: _currentComplexity.toString(),
                    value: _currentComplexity.toDouble(),
                    activeColor: Colors.red[_currentComplexity * 100 ?? 0],
                    inactiveColor: Colors.red[_currentComplexity * 100 ?? 0],
                    min: 1,
                    max: 5,
                    divisions: 4,
                    onChanged: (val) => setState(
                      () => _currentComplexity = val.round(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Cancel"),
                        color: Colors.red.shade100,
                      ),
                      Visibility(
                        visible: _parsedDueDate != "",
                        child: FlatButton(
                            child: Text("Add Test"),
                            color: Colors.green.shade100,
                            onPressed: () async {
                              if (_formKey.currentState.validate() &&
                                  _parsedDueDate != "" &&
                                  isLoading == false) {
                                setState(() {
                                  isLoading = true;
                                });
                                final testId =
                                    await DatabaseService(uid: _userData.uid)
                                        .createNewTest(
                                            _currentSubject ?? "",
                                            _currentComplexity ?? 0,
                                            _currentImportance ?? 0,
                                            _currentDescription ?? "",
                                            _currentDueDate,
                                            _userData);
                                _showWebColoredToast();
                                await TimeAllocation(
                                        userData: _userData,
                                        finalSessions: [],
                                        complexity: _currentComplexity,
                                        dueDate: _currentDueDate,
                                        testId: testId)
                                    .calculateSessions();
                                if (this.mounted) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  Navigator.pop(context);
                                }
                              }
                            }),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  void _showWebColoredToast() {
    Fluttertoast.showToast(
      msg:
          "$_currentSubject Test And $_currentComplexity new study sessions were added to your calendar",
      toastLength: Toast.LENGTH_LONG,
      textColor: Colors.black,
      fontSize: 20,
      backgroundColor: Colors.green.shade200,
      timeInSecForIosWeb: 5,
    );
  }
}
