
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/rendering.dart';
import 'package:prodd/data/auth_service.dart';
import 'package:prodd/data/goal_repository.dart';
import 'package:prodd/routes.dart';
import 'package:prodd/screens/login/login_screen.dart';

import 'screens/home/goals/add_edit_goal_screen.dart';
import 'screens/home/home_screen.dart';

void main() {
  Crashlytics.instance.enableInDevMode = true;

  // Pass all uncaught errors to Crashlytics.
  FlutterError.onError = (FlutterErrorDetails details) {
    Crashlytics.instance.onError(details);
  };

  debugPaintSizeEnabled=false; 
  
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static final FirebaseAnalytics analytics = FirebaseAnalytics();
  static final FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  static final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  
  @override
  void initState() {
    _firebaseMessaging.configure(onMessage: (x) async => print(x));
    _firebaseMessaging.subscribeToTopic('dev-topic');

    super.initState();
    AuthService().uidStream.listen((x) => print("uid" + x));
    AuthService().isAuthenticated.listen((a) {
      if (a) {
        MyApp.navigatorKey.currentState.pushNamedAndRemoveUntil(AppRoutes.goals, (_) => false);
      } else {
        MyApp.navigatorKey.currentState.pushNamedAndRemoveUntil(AppRoutes.login, (_) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'Prodd',
      routes: {
        AppRoutes.login: (context) => LoginScreen(),
        AppRoutes.goals: (context) => HomeScreen(initialIndex: 0),
        AppRoutes.goalAddEdit: (context) => AddEditGoalScreen(goalRepo: GoalRepository(AuthService().uid)),
      },
      initialRoute: AppRoutes.login,
      color: Colors.orange[350],
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.orange[700],
        accentColorBrightness: Brightness.light,
        //buttonTheme: ButtonThemeData(highlightColor: Colors.purple[50])
      ),
      navigatorObservers: [
        MyApp.observer,
      ],
      navigatorKey: MyApp.navigatorKey,
    );
  }
}
