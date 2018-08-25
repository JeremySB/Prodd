import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:prodd/data/goal_repository.dart';
import 'package:prodd/models/change.dart';
import 'package:prodd/models/goal.dart';
import 'package:prodd/routes.dart';
import 'package:prodd/screens/goals/add_edit_goal_screen.dart';

class GoalScreen extends StatelessWidget {
  GoalScreen({this.goalRepo});

  final GoalRepository goalRepo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Active Goals'),
      ),
      body: GoalList(goalRepo: goalRepo),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.goalAddEdit);
        }
      ),
    );
  }
}

class GoalList extends StatefulWidget {
  GoalList({this.goalRepo});

  final GoalRepository goalRepo;

  @override
  State<StatefulWidget> createState() => _GoalListState();
}

class _GoalListState extends State<GoalList> {

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<Goal> goals = List();

  @override
  void initState() {
    super.initState();

    widget.goalRepo.activeGoalChangesStream().listen((List<Change<Goal>> changes) {
      changes.forEach((change) {
        switch (change.type) {
          case ChangeType.added:
            goals.insert(change.newIndex, change.data);
            _listKey.currentState.insertItem(change.newIndex);
            break;
          case ChangeType.modified:
            goals.removeAt(change.oldIndex);
            goals.insert(change.newIndex, change.data);
            break;
          case ChangeType.removed:
            goals.removeAt(change.oldIndex);
            _listKey.currentState.removeItem(change.oldIndex, (context, animation) {
              return Text("bye");
            });
            break;
        }
      });
      setState(() {
        
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: _listKey,
      itemBuilder: (context, i, animation) {
        return _GoalItem(goal: goals[i], goalRepo: widget.goalRepo);
      },
    );
  }
}

class _GoalItem extends StatelessWidget {
  _GoalItem({this.goal, this.goalRepo});

  final Goal goal;
  final GoalRepository goalRepo;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(goal.title),
      subtitle: goal.completeBy != null ? Text(DateFormat().add_yMEd().add_jm().format(goal.completeBy)) : null,
      leading: IconButton(
        icon: Icon(Icons.check_box_outline_blank),
        onPressed: () {
          goal.status = GoalStatus.completed;
          goalRepo.saveGoal(goal);
        },
      ),
      //trailing: Text(goal.status.toString()),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AddEditGoalScreen(goal: goal, goalRepo: goalRepo,)
      )),
    );
  }

}