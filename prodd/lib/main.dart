import 'package:flutter/material.dart';
import 'package:prodd/data/goal_repository.dart';
import 'package:prodd/models/goal.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prodd',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Goals'),
        ),
        body: GoalList()
      ),
    );
  }
}

class GoalList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var repo = GoalRepository(); 
    return StreamBuilder<List<Goal>>(
      stream: repo.goalStream(),
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