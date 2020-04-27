import 'package:flutter/material.dart';
import 'package:study_calendar/models/test.dart';
import 'package:study_calendar/screens/home/test_tile.dart';
import 'package:provider/provider.dart';

class TestList extends StatefulWidget {
  @override
  _TestListState createState() => _TestListState();
}

class _TestListState extends State<TestList> {
  @override
  Widget build(BuildContext context) {
    print("tests List build");
    List<Test> tests = Provider.of<List<Test>>(context);

    return ListView.builder(
      /*   shrinkWrap: true, */
      itemCount: tests == null ? 0 : tests?.length,
      itemBuilder: (context, index) {
        return TestTile(test: tests[index] ?? "");
      },
    );
  }
}
