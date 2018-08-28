import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:prodd/data/goal_repository.dart';
import 'package:prodd/models/goal.dart';

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
    final bool editing = widget.goal != null;
    final goal = widget.goal ?? Goal();
    
    return Scaffold(
      appBar: AppBar(title: Text(editing ? "Edit Goal" : "Add Goal"),),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              // title field
              ListTile(
                leading: Icon(Icons.title),
                title: TextFormField(
                  initialValue: goal?.title,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: "Goal title"
                  ),
                  validator: (val) => val.trim().isEmpty ? "Cannot be empty" : null,
                  onSaved: (val) => goal.title = val.trim(),
                ),
              ),
              
              // due date / complete by field
              FormField<DateTime>(
                initialValue: goal.completeBy,
                onSaved: (val) => goal.completeBy = val,
                builder: (state) {
                  return ListTile(
                    leading: Icon(Icons.date_range),
                    title: Text("Due date"),
                    subtitle: Text(state.value != null ? DateFormat().add_yMEd().add_jm().format(state.value) : "No date selected"),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context, 
                        firstDate: DateTime(2015), 
                        initialDate: state.value ?? DateTime.now(), 
                        lastDate: DateTime(2100)
                      );
                      if(date == null) return;
                      
                      final currentTime = TimeOfDay.fromDateTime(state.value ?? DateTime.now());
                      final time = await showTimePicker(
                        context: context,
                        initialTime: currentTime
                      );
                      if(time == null) {
                        return;
                      }
                      
                      state.didChange(DateTime(date.year, date.month, date.day, time.hour, time.minute));
                    },
                    onLongPress: () => state.didChange(null),
                  );
                }
              ),

              // estimated duration
              ListTile(
                leading: Icon(Icons.timelapse),
                title: TextFormField(
                  initialValue: goal?.estimatedDuration?.inMinutes?.toString(),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Estimated duration (minutes)"
                  ),
                  validator: (val) {
                    if(val.isNotEmpty && int.tryParse(val) == null) {
                      return "Not a valid number";
                    }
                    return null;
                  },
                  onSaved: (val) => goal.estimatedDuration = int.tryParse(val) != null ? Duration(minutes: int.parse(val)) : null,
                ),
              ),
              
              // when to start notifying
              FormField<DateTime>(
                initialValue: goal.beginNotifications,
                onSaved: (val) => goal.beginNotifications = val,
                builder: (state) {
                  return ListTile(
                    leading: Icon(Icons.play_arrow),
                    title: Text("Begin notifications date (\"prodding\")"),
                    subtitle: Text(state.value != null ? DateFormat().add_yMEd().format(state.value) : "Automatic"),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context, 
                        firstDate: DateTime(2015), 
                        initialDate: state.value ?? DateTime.now(), 
                        lastDate: DateTime(2100)
                      );
                      if(date == null) return;
                      
                      
                      state.didChange(DateTime(date.year, date.month, date.day));
                    },
                    onLongPress: () => state.didChange(null),
                  );
                }
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.send),
        onPressed: () {
          if(_formKey.currentState.validate()) {
            _formKey.currentState.save();
            widget.goalRepo.saveGoal(goal);
            Navigator.of(context).pop();
          }
          else {
            FirebaseAnalytics().logEvent(name: "goal_validation_failed", parameters: {"goal": goal, "to_string": _formKey.currentWidget.toStringDeep()});
          }
        }
      )
    );
  }
}