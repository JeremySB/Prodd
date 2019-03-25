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
              child: Text("Skip Login"),
              onPressed: () => AuthService().signInAnonymously().then((success) =>
                success ? Navigator.of(context).pushReplacementNamed(AppRoutes.goals) : null),
            )
          ],
        )
      ),
    );
  }
}
