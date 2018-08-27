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

  List<Goal> goals = List(), removedGoals = List();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  bool _loading = true;

  @override
  void initState() {
    super.initState();

    widget.goalRepo.activeGoalChangesStream().listen((List<Change<Goal>> changes) {
      if(_loading) {
        goals = changes.map((c) => c.data).toList();
        _loading = false;
      }
      else {
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
              removedGoals.add(change.data);
              final i = removedGoals.length - 1;
              _listKey.currentState.removeItem(change.oldIndex, (context, animation) {
                return ScaleTransition(
                  scale: animation,
                  child: _GoalItem(goal: removedGoals[i], removing: true)
                );
              }, duration: Duration(milliseconds: 200));
              break;
          }
        });
      }

      setState(() {
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if(_loading) {
      return Text("Loading");
    }
    return AnimatedList(
      key: _listKey,
      initialItemCount: goals.length,
      itemBuilder: (context, i, animation) {
        return _GoalItem(goal: goals[i], goalRepo: widget.goalRepo);
      },
    );
  }
}

class _GoalItem extends StatelessWidget {
  _GoalItem({@required this.goal, this.goalRepo, this.removing = false})
    : assert(goal != null);

  final Goal goal;
  final GoalRepository goalRepo;
  final bool removing;

  void _onComplete() {
    goal.status = GoalStatus.completed;
    goalRepo?.saveGoal(goal);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(goal.title),
      subtitle: goal.completeBy != null ? Text(DateFormat().add_yMEd().add_jm().format(goal.completeBy)) : null,
      leading: IconButton(
        icon: Icon(removing ? Icons.check_box : Icons.check_box_outline_blank),
        onPressed: _onComplete,
      ),
      //trailing: Text(goal.status.toString()),
      onTap: () {
        if(removing) return;
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddEditGoalScreen(goal: goal, goalRepo: goalRepo,)
        ));
      },
    );
  }
}