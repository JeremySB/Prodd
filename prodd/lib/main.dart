import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:prodd/data/auth_service.dart';
import 'package:prodd/data/goal_repository.dart';
import 'package:prodd/routes.dart';
import 'package:prodd/screens/goals/add_edit_goal_screen.dart';
import 'package:prodd/screens/goals/goal_screen.dart';
import 'package:prodd/screens/login/login_screen.dart';

void main() {
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
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    AuthService().uidStream.listen((x) => print("uid" + x));
    AuthService().isAuthenticated.listen((a) {
      if (a) {
        //MyApp.navigatorKey.currentState.pushNamedAndRemoveUntil(AppRoutes.goals, (_) => false);
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
        AppRoutes.goals: (context) => GoalScreen(goalRepo: GoalRepository(AuthService().uid)),
        AppRoutes.goalAddEdit: (context) => AddEditGoalScreen(goalRepo: GoalRepository(AuthService().uid)),
      },
      initialRoute: AppRoutes.goals,
      color: Colors.orange[350],
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      navigatorObservers: [
        MyApp.observer,
      ],
      navigatorKey: MyApp.navigatorKey,
    );
  }
}
