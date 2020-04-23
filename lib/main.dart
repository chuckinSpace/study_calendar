import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:study_calendar/models/test.dart';
import 'package:study_calendar/models/user_data.dart';
import 'package:study_calendar/services/database.dart';
import 'package:study_calendar/wrapper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  @override
  Widget build(BuildContext awaitcontext) {
    return StreamProvider<FirebaseUser>.value(
      value: FirebaseAuth.instance.onAuthStateChanged,
      child: AppWrapper(
        analytics: analytics,
        observer: observer,
      ),
    );
  }
}

class AppWrapper extends StatefulWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  AppWrapper({
    this.analytics,
    this.observer,
  });

  @override
  _AppWrapperState createState() => _AppWrapperState(analytics, observer);
}

class _AppWrapperState extends State<AppWrapper> {
  _AppWrapperState(this.analytics, this.observer);
  final FirebaseAnalyticsObserver observer;
  final FirebaseAnalytics analytics;
  @override
  Widget build(BuildContext context) {
    DatabaseService _database;
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    var _user = Provider.of<FirebaseUser>(context);

    _database = DatabaseService();
    return MultiProvider(
      providers: [
        StreamProvider<List<Test>>.value(
          value: _database.streamTests(_user?.uid),
        ),
        StreamProvider<UserData>.value(
          value: _database.streamUserData(_user?.uid),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        navigatorObservers: <NavigatorObserver>[observer],
        theme: ThemeData(
          primaryColor: Color(0xFF4F3961),
          accentColor: Color(0xFFFFFFFF),
          appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(color: Colors.black),
            color: Colors.white,
          ),
          backgroundColor: Colors.grey.shade100,
          buttonColor: Color(0xFFFFFFFF),
          textTheme: TextTheme(
            title: TextStyle(
              fontSize: 20.0,
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
            body1: TextStyle(
                fontSize: 14.0, fontFamily: 'Hind', color: Colors.black),
            button: TextStyle(
                fontSize: 14.0, fontFamily: 'Hind', color: Colors.black),
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: Wrapper(analytics: widget.analytics, observer: widget.observer),
        builder: (BuildContext context, Widget widget) {
          createBannerAd(isIOS)
            ..load()
            ..show();

          bool isKeyboardOpen = false;
          isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;
          final screenHeight = MediaQuery.of(context).size.height;

          double paddingBottom = isIOS ? 90.0 : 60.0;
          if (screenHeight <= 400) paddingBottom = 30;
          if (screenHeight > 400) paddingBottom = 50;
          if (screenHeight > 720) paddingBottom = 90;

          return Padding(
            child: widget,
            padding: EdgeInsets.only(
                bottom: isKeyboardOpen ? 0 : paddingBottom, right: 0),
          );
        },
      ),
    );
  }
}

MobileAdTargetingInfo targetInfo = new MobileAdTargetingInfo(
  testDevices: <String>[],
  keywords: <String>["scheduling, time management, school,tests,exam"],
  childDirected: true,
);

BannerAd createBannerAd(bool isIOS) {
  return new BannerAd(
      adUnitId: /* BannerAd
          .testAdUnitId  */
          isIOS
              ? "ca-app-pub-7595932337183148/8586377663"
              : "ca-app-pub-7595932337183148/8039582759",
      size: AdSize.smartBanner,
      targetingInfo: targetInfo,
      listener: (MobileAdEvent event) {});
}
