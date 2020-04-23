import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:study_calendar/items.dart';
import 'package:study_calendar/services/database.dart';

import 'home/home.dart';

class WelcomeScreen extends StatefulWidget {
  final String uid;
  WelcomeScreen(this.uid);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  List<Widget> slides = items
      .map((item) => new Container(
          decoration: BoxDecoration(color: Colors.white),
          padding: EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            children: <Widget>[
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Image.asset(
                  item['image'],
                  fit: BoxFit.fitWidth,
                  width: 220.0,
                  alignment: Alignment.bottomCenter,
                ),
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      children: <Widget>[
                        Text(item['header'],
                            style: TextStyle(
                                fontSize: 50.0,
                                fontWeight: FontWeight.w300,
                                color: Color(0XFF3F3D56),
                                height: 2.0)),
                        Text(
                          item['description'],
                          style: TextStyle(
                              color: Colors.grey,
                              letterSpacing: 1.2,
                              fontSize: 16.0,
                              height: 1.3),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          )))
      .toList();

  List<Widget> indicator() => List<Widget>.generate(
      slides.length,
      (index) => Container(
            margin: EdgeInsets.symmetric(horizontal: 3.0),
            height: 10.0,
            width: 10.0,
            decoration: BoxDecoration(
                color: currentPage.round() == index
                    ? Color(0XFF256075)
                    : Color(0XFF256075).withOpacity(0.2),
                borderRadius: BorderRadius.circular(10.0)),
          ));

  double currentPage = 0.0;
  final _pageViewController = new PageController();

  @override
  Widget build(BuildContext mainContext) {
    bool _showHome = false;
    return Scaffold(
      appBar: AppBar(elevation: 0, actions: [
        Visibility(
          visible: _showHome,
          child: IconButton(
              icon: FaIcon(
                FontAwesomeIcons.home,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
              }),
        )
      ]),
      body: Container(
        child: Stack(
          children: <Widget>[
            PageView.builder(
              controller: _pageViewController,
              itemCount: slides.length,
              itemBuilder: (BuildContext context, int index) {
                _pageViewController.addListener(() async {
                  setState(() {
                    currentPage = _pageViewController.page;
                  });
                  if (index == slides.length - 1) {
                    Future.delayed(const Duration(seconds: 4), () async {
                      if (this.mounted) {
                        await DatabaseService().updateDocument("users",
                            this.widget.uid, {"isWelcomeScreenSeen": true});
                      }

                      if (this.mounted) {
                        setState(() {
                          _showHome = true;
                        });
                      }
                    });
                  }
                });

                return slides[index];
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(top: 70.0),
                padding: EdgeInsets.symmetric(vertical: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: indicator(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
