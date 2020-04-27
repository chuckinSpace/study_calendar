import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:study_calendar/constants.dart';
import 'package:study_calendar/generated/l10n.dart';
import 'package:study_calendar/helpers/TimeAllocation.dart';
import 'package:study_calendar/models/user_data.dart';
import 'package:study_calendar/services/database.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:tutorial_coach_mark/animated_focus_light.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  FocusNode thirdSecondFocusNode = new FocusNode();
  FocusNode textSecondFocusNode = new FocusNode();
  final _formKey = GlobalKey<FormState>();
  GlobalKey _complexityKey = GlobalKey();
  int numOfFinalSessions = 0;
  String _currentSubject;
  int _currentComplexity = 1;
  int _currentImportance = 1;
  String _currentDescription = "";
  DateTime _currentDay = DateTime.now();
  DateTime _currentStartTime = DateTime.now();
  DateTime _currentEndTime = DateTime.now();
  List<TargetFocus> targets = List();
  DateTime _currentDueDate =
      DateTime.now().add(new Duration(days: 1)).add(new Duration(hours: 1));
  String _parsedDueDate = "";
  String _parsedStartTime = "";
  String _parsedEndTime = "";
  bool isLoading = false;
  int _daysUntilTest = 1;
  TimeOfDay _timeToStart;

  Future<void> _showDateTimePicker(BuildContext context) async {
    DateTime daySelected = await showRoundedDatePicker(
      initialDate: DateTime.now()
          .add(new Duration(days: 1))
          .add(new Duration(seconds: 30)),
      firstDate: DateTime.now().add(new Duration(days: 1)),
      context: context,
      theme: ThemeData(primarySwatch: Colors.blue),
    );

    if (daySelected != null) {
      setState(() {
        _currentDay = daySelected;
      });
    }

    setState(() {
      _currentDueDate = new DateTime(
          _currentDay.year,
          _currentDay.month,
          _currentDay.day,
          _currentStartTime.hour,
          _currentStartTime.minute,
          0,
          0);

      _parsedDueDate = new DateFormat("MMMM, EEEE d").format(DateTime(
          _currentDay.year,
          _currentDay.month,
          _currentDay.day,
          _currentStartTime.hour,
          _currentStartTime.minute,
          0,
          0));
      if (daySelected != null) {
        var daysToTest = TimeAllocation().daysUntil(_currentDueDate);
        if (daysToTest == 0) {
          daysToTest = 1;
        } else if (daysToTest > 30) {
          _daysUntilTest = 30;
        } else {
          _daysUntilTest = daysToTest;
        }

        print("_daysUntilTest $_daysUntilTest");
      }
    });
  }

  Future<void> _setStartTime() async {
    final startTimeSelected = await showRoundedTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (startTimeSelected != null) {
      _timeToStart = startTimeSelected;
      setState(() {
        _currentStartTime = new DateTime(
            _currentDueDate.year,
            _currentDueDate.month,
            _currentDueDate.day,
            startTimeSelected.hour,
            startTimeSelected.minute,
            0,
            0,
            0);
        _parsedStartTime = new DateFormat("h:mm a").format(_currentStartTime);
      });
    }
  }

  Future<void> _setEndTime(BuildContext context) async {
    final endTimeSelected = await showRoundedTimePicker(
      context: context,
      initialTime: _timeToStart ?? TimeOfDay.now(),
    );
    if (endTimeSelected != null) {
      _currentEndTime = new DateTime(
          _currentDueDate.year,
          _currentDueDate.month,
          _currentDueDate.day,
          endTimeSelected.hour,
          endTimeSelected.minute,
          0,
          0,
          0);

      if (_currentEndTime.isBefore(_currentStartTime)) {
        _showEndError(context);
        setState(() {
          _parsedEndTime = "";
        });
      } else {
        setState(() {
          _parsedEndTime = new DateFormat("h:mm a").format(_currentEndTime);
        });
      }
    }
  }

  didChangeDependencies() async {
    initTargets();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final _userData = Provider.of<UserData>(context);

    return Form(
      key: _formKey,
      child: isLoading
          ? Container(
              child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Container(
                child: Column(
                  children: <Widget>[
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: AutoSizeText(
                          "${S.of(context).addingSessions}",
                          style: TextStyle(
                              fontSize: 15, fontStyle: FontStyle.italic),
                          maxLines: 1,
                        ),
                      )
                    ]),
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: SpinKitFoldingCube(
                          color: Theme.of(context).primaryColor, size: 150),
                    ),
                  ],
                ),
              ),
            ))
          : Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(S.of(context).addTest,
                        style: Theme.of(context).textTheme.title)
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
                SizedBox(height: 15),
                Row(
                  children: <Widget>[
                    Flexible(
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: textInputDecoration.copyWith(
                            hintText: S.of(context).courseCode),
                        validator: (val) =>
                            val.isEmpty ? S.of(context).enterSubject : null,
                        onChanged: (val) =>
                            setState(() => _currentSubject = val),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Flexible(
                      child: TextFormField(
                        decoration: textInputDecoration.copyWith(
                            hintText: S.of(context).description),
                        validator: (val) =>
                            val.isEmpty ? S.of(context).enterDescription : null,
                        onChanged: (val) {
                          setState(() => _currentDescription = val);
                        },
                      ),
                    ),
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
                          FocusScope.of(context)
                              .requestFocus(textSecondFocusNode);
                        },
                        tooltip: S.of(context).dueDate,
                        child: Icon(Icons.calendar_today),
                        foregroundColor: Colors.black,
                        backgroundColor: _parsedDueDate == ""
                            ? Colors.teal.shade100
                            : Colors.blue.shade400,
                        elevation: 0),
                    SizedBox(width: 10),
                    AutoSizeText(
                      "${S.of(context).dueDate} :",
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                    AutoSizeText(
                      _parsedDueDate == ""
                          ? S.of(context).pickADate
                          : " $_parsedDueDate",
                      style: TextStyle(
                        color: _parsedDueDate == ""
                            ? Colors.red.shade400
                            : Colors.black,
                      ),
                      maxLines: 1,
                      maxFontSize: 14,
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 200.0,
                      child: Text(
                        "${S.of(context).start}: $_parsedStartTime",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    IconButton(
                        focusNode: textSecondFocusNode,
                        icon: FaIcon(FontAwesomeIcons.clock, size: 25),
                        onPressed: () async {
                          await _setStartTime();
                          FocusScope.of(context)
                              .requestFocus(thirdSecondFocusNode);
                        }),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 200.0,
                      child: Text(
                        "${S.of(context).end}: $_parsedEndTime",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    Visibility(
                      visible: _parsedStartTime != "",
                      child: IconButton(
                          focusNode: thirdSecondFocusNode,
                          icon: FaIcon(FontAwesomeIcons.clock, size: 25),
                          onPressed: () async {
                            await _setEndTime(context);
                          }),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Visibility(
                  visible: _daysUntilTest > 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      AutoSizeText(
                        S.of(context).testComplexity,
                        minFontSize: 20,
                      ),
                      IconButton(
                        key: _complexityKey,
                        onPressed: _showComplexity,
                        tooltip: S.of(context).whatIsThis,
                        icon: FaIcon(
                          FontAwesomeIcons.questionCircle,
                          size: 17,
                        ),
                      )
                    ],
                  ),
                ),
                Visibility(
                  visible: _daysUntilTest > 1,
                  child: Slider(
                    label: _currentComplexity.toString(),
                    value: _currentComplexity.toDouble() <=
                            _daysUntilTest.toDouble()
                        ? _currentComplexity.toDouble()
                        : 1,
                    activeColor: Colors.red[_currentComplexity * 100 ?? 0],
                    inactiveColor: Colors.red[_currentComplexity * 100 ?? 0],
                    min: 1,
                    max: _daysUntilTest.toDouble() > 30
                        ? 30.0
                        : _daysUntilTest.toDouble(),
                    divisions: _daysUntilTest > 30 ? 30 : _daysUntilTest,
                    onChanged: (val) => setState(
                      () => _currentComplexity = val.round(),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(S.of(context).cancel),
                      color: Colors.red.shade200,
                    ),
                    Visibility(
                      visible: _parsedDueDate != "" &&
                          _parsedStartTime != "" &&
                          _parsedEndTime != "",
                      child: FlatButton(
                          child: Text(S.of(context).addTest),
                          color: Colors.green.shade100,
                          onPressed: () async {
                            if (_formKey.currentState.validate() &&
                                _parsedDueDate != "" &&
                                _parsedEndTime != "" &&
                                _parsedStartTime != "" &&
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
                                          _currentStartTime,
                                          _currentEndTime,
                                          _userData,
                                          context);

                              numOfFinalSessions = await TimeAllocation(
                                      userData: _userData,
                                      finalSessions: [],
                                      complexity: _currentComplexity,
                                      dueDate: _currentDueDate,
                                      testId: testId)
                                  .calculateSessions(context);
                              _showWebColoredToast(context);
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
    );
  }

  void _showComplexity() async {
    TutorialCoachMark(context,
        targets: targets,
        colorShadow: Colors.teal.shade200,
        textSkip: S.of(context).done,
        paddingFocus: 5,
        alignSkip: Alignment.bottomCenter,
        opacityShadow: 1,
        finish: () {}, clickTarget: (target) {
      print(target);
    }, clickSkip: () {})
      ..show();
  }

  void _showWebColoredToast(BuildContext context) {
    String message = "";
    if (numOfFinalSessions == 0) {
      message = S.of(context).noTimeForSessions;
    } else if (numOfFinalSessions == 1) {
      message = "$_currentSubject ${S.of(context).oneSessionCreated}";
    } else {
      message =
          "$_currentSubject Test ${S.of(context).and} $numOfFinalSessions ${S.of(context).moreSessionsCreated} ";
    }
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      textColor: Colors.black,
      fontSize: 15,
      backgroundColor: Colors.green.shade200,
      timeInSecForIosWeb: 5,
    );
  }

  void _showEndError(BuildContext context) {
    Fluttertoast.showToast(
      msg: S.of(context).endDateError,
      toastLength: Toast.LENGTH_LONG,
      textColor: Colors.black,
      fontSize: 15,
      backgroundColor: Colors.red.shade200,
      timeInSecForIosWeb: 5,
    );
  }

  void initTargets() {
    targets.add(TargetFocus(
      identify: "Commplexity",
      keyTarget: _complexityKey,
      contents: [
        ContentTarget(
            align: AlignContent.top,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    S.of(context).testComplexity,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 25.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      S.of(context).testComplexityTut,
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  )
                ],
              ),
            ))
      ],
      shape: ShapeLightFocus.RRect,
    ));
  }
}
