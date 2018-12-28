
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';


class AuthService {

  static AuthService _instance;

  final Stream<String> uid;

  Stream<String> get uid2 { 
    return FirebaseAuth.instance.onAuthStateChanged.map((x) => x.uid);
  }

  factory AuthService() {
    if(_instance == null) _instance = AuthService._();
    return _instance;
  }

  AuthService._() 
    : uid = FirebaseAuth.instance.onAuthStateChanged.map((x) => x.uid).asBroadcastStream() 
  {
    FirebaseAuth.instance.currentUser().then((user) {
      if(user == null) {
        FirebaseAuth.instance.signInAnonymously().catchError((error) => print("Error: " + error.error));
      }
    });
  }
}