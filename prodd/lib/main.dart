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

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static final FirebaseAnalytics analytics = FirebaseAnalytics();
  static final FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    AuthService().uid.listen((x) => print(x));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prodd',
      routes: {
        AppRoutes.goals: (context) => _authGuard(),
        AppRoutes.goalAddEdit: (context) => AddEditGoalScreen(goalRepo: GoalRepository(AuthService().lastUid))
      },
      initialRoute: AppRoutes.goals,
      color: Colors.orange[350],
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      navigatorObservers: [
        MyApp.observer,
      ],
    );
  }

  Widget _authGuard() {
    return StreamBuilder(
      stream: AuthService().uid,
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.data != null && snapshot.data != "")
          return GoalScreen(goalRepo: GoalRepository(snapshot.data));
        return Scaffold(
          appBar: AppBar(
            title: Text('Authentication Error'),
          )
        );
      },
    );
  }
}
