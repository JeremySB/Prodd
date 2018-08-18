import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:prodd/data/goal_repository.dart';
import 'package:prodd/models/goal.dart';
import 'package:prodd/widgets/date_time_picker.dart';

class AddEditGoalScreen extends StatefulWidget {
  AddEditGoalScreen({this.goal, this.goalRepo});

  final Goal goal;
  final GoalRepository goalRepo;

  @override
  State<StatefulWidget> createState() {
    return AddEditGoalScreenState();
  }

}

class AddEditGoalScreenState extends State<AddEditGoalScreen> {
  
  final _formKey = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
    final goal = widget.goal ?? Goal();
    
    return Scaffold(
      appBar: AppBar(title: Text(goal == null ? "Add Goal" : "Edit Goal"),),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(8.0),
            children: <Widget>[
              // title field
              TextFormField(
                initialValue: goal?.title,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: "Goal title",
                  icon: Icon(Icons.title)
                ),
                validator: (val) => val.trim().isEmpty ? "Cannot be empty" : null,
                onSaved: (val) => goal.title = val.trim(),
              ),

              DateTimePicker(
                onSaved: (val) => goal.completeBy = val != null ? val : goal.completeBy
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {
          _formKey.currentState.save();
          widget.goalRepo.saveGoal(goal);
          Navigator.of(context).pop();
        }
      )
    );
  }
}