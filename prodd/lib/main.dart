import 'package:flutter/material.dart';

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
    return ListView(
      children: <Widget>[GoalItem(), GoalItem()],
    );
  }

}

class GoalItem extends StatelessWidget {
  final name = "Goal item";

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      leading: Icon(Icons.inbox),
    );
  }

}