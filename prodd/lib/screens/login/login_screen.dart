import 'package:flutter/material.dart';
import 'package:prodd/data/auth_service.dart';
import 'package:prodd/routes.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var loading = false;

  Widget _loadingView() {
    return Center(child: CircularProgressIndicator(value: null,),);
  }

  void _onGoogleSignIn() {
    setState(() => loading = true);
    AuthService().signInWithGoogle().catchError((e) {
      setState(() => loading = false);
      print("Google sign in failed: $e");
    });
  }
  
  void _onAnonSignIn() {
    setState(() => loading = true);
    AuthService().signInAnonymously().catchError((e) {
      setState(() => loading = false);
      print("Anon sign in failed: $e");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: loading ? _loadingView() : Container(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
        alignment: Alignment(0, 0.4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            OutlineButton(
              child: Text("Sign in with Google"),
              onPressed: _onGoogleSignIn 
            ),
            OutlineButton(
              child: Text("Sign in with password"), onPressed: null,
            ),
            OutlineButton(
              child: Text("Skip Login"),
              onPressed: _onAnonSignIn
            )
          ],
        )
      ),
    );
  }
}
