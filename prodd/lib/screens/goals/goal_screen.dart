import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:prodd/data/goal_repository.dart';
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

class GoalList extends StatelessWidget {
  GoalList({this.goalRepo});

  final GoalRepository goalRepo;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Goal>>(
      stream: goalRepo.activeGoalStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: const Text('Loading...')); 
        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (_, i) {
            return _GoalItem(goal: snapshot.data[i], goalRepo: goalRepo,);
          },
        );
      }
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
      leading: GestureDetector(
        child: Icon(Icons.check_box_outline_blank),
        onTap: () {
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