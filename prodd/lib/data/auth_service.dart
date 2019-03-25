
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';


class AuthService {

  static AuthService _instance;

  BehaviorSubject<FirebaseUser> _userSubject = BehaviorSubject<FirebaseUser>();

  Stream<String> get uidStream { 
    return _userSubject.stream.map((x) => x.uid);
  }

  Stream<bool> get isAuthenticated {
    return _userSubject.stream.map((x) => x != null);
  }

  String get uid {
    return _userSubject.value?.uid ?? "";
  }

  factory AuthService() {
    if(_instance == null) _instance = AuthService._();
    return _instance;
  }

  AuthService._() {
    _userSubject.addStream(FirebaseAuth.instance.onAuthStateChanged);
    // FirebaseAuth.instance.currentUser().then((user) {
    //   if(user == null) {
    //     FirebaseAuth.instance.signInAnonymously().catchError((error) => print("Error: " + error.error));
    //   }
    // });
  }

  Future<bool> signInAnonymously() async {
    var user = await FirebaseAuth.instance.signInAnonymously();
    return user != null;
  }
}