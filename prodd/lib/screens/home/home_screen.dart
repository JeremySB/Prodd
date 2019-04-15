import 'package:flutter/material.dart';
import 'package:prodd/data/auth_service.dart';

import 'goals/goal_screen.dart';

class HomeScreen extends StatefulWidget {
  final int _initialIndex;

  HomeScreen({int initialIndex}) 
    : this._initialIndex = initialIndex ?? 0;

  @override
  State<StatefulWidget> createState() => _HomeScreenState(_initialIndex);
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex;
  final _widgetOptions = [
    GoalScreen(),
    Text("soon")
  ];

  _HomeScreenState(this._selectedIndex);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('prodd'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            tooltip: "Logout",
            onPressed: () => AuthService().signOut(),
          )
        ]
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Goals')),
          BottomNavigationBarItem(icon: Icon(Icons.settings), title: Text('Settings')),
        ],
        currentIndex: _selectedIndex,
        fixedColor: Colors.deepPurple,
        onTap: (i) => setState(() => this._selectedIndex = i),
      ),
    );
  }
}
