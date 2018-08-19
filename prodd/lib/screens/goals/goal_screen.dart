import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
        title: Text('Prodd: Goals'),
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
      stream: goalRepo.goalStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Text('Loading...'); 
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
      leading: Icon(Icons.inbox),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AddEditGoalScreen(goal: goal, goalRepo: goalRepo,)
      )),
    );
  }

}