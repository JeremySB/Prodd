

import 'package:flutter/material.dart';
import 'package:prodd/data/auth_service.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Column(
        children: <Widget>[
          RaisedButton(
            child: Text("Skip Login"),
            onPressed: () => AuthService().signInAnonymously().then((_) => print("doot")),
          )
        ],
      ),
    );
  }

}
