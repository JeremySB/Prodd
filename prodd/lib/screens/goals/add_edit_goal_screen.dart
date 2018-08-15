import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:prodd/data/goal_repository.dart';
import 'package:prodd/models/goal.dart';

class AddEditGoalScreen extends StatelessWidget {
  AddEditGoalScreen({this.goal, this.goalRepo});

  final Goal goal;
  final GoalRepository goalRepo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(goal == null ? "Add Goal" : "Edit Goal"),),
      body: Form(
        child: ListView(
          padding: EdgeInsets.all(8.0),
          children: <Widget>[
            TextFormField(
              initialValue: goal?.title,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: "Goal title",
                icon: Icon(Icons.title)
              ),
              validator: (val) => val.trim().isEmpty ? "Cannot be empty" : null,
            )
          ],
        ),
      ),
    );
  }

}