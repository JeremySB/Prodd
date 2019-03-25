import 'package:flutter/material.dart';
import 'package:prodd/data/auth_service.dart';
import 'package:prodd/routes.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            OutlineButton(
              child: Text("Login With Google"),
              onPressed: () => AuthService().signInWithGoogle().catchError((e) => print("Google signin failed $e")),
            ),
            OutlineButton(
              child: Text("Skip Login"),
              onPressed: () => AuthService().signInAnonymously(),
            )
          ],
        )
      ),
    );
  }
}
