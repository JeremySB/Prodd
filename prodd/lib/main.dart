import 'package:flutter/material.dart';
import 'package:prodd/data/goal_repository.dart';
import 'package:prodd/routes.dart';
import 'package:prodd/screens/goals/add_edit_goal_screen.dart';
import 'package:prodd/screens/goals/goal_screen.dart';

void main() {
  // hopefully can remove this later
  MaterialPageRoute.debugEnableFadingRoutes = true;

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GoalRepository _goalRepo = GoalRepository();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prodd',
      routes: {
        AppRoutes.goals: (context) => GoalScreen(goalRepo: _goalRepo),
        AppRoutes.goalAddEdit: (context) => AddEditGoalScreen(goalRepo: _goalRepo)
      },
      initialRoute: AppRoutes.goals,
    );
  }
}
