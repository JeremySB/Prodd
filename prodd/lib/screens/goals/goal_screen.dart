import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:prodd/data/goal_repository.dart';
import 'package:prodd/models/goal.dart';
import 'package:prodd/routes.dart';

class GoalScreen extends StatelessWidget {
  GoalScreen({this.goalRepo});

  final GoalRepository goalRepo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Goals'),
      ),
      body: GoalList(goalRepo: goalRepo),
      floatingActionButton: FloatingActionButton(
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
            return GoalItem(goal: snapshot.data[i]);
          },
        );
      }
    );
  }
}

class GoalItem extends StatelessWidget {
  GoalItem({this.goal});

  final Goal goal;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(goal.title),
      leading: Icon(Icons.inbox),
    );
  }

}