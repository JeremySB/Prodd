
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';


class AuthService {

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  static AuthService _instance;

  BehaviorSubject<FirebaseUser> _userSubject = BehaviorSubject<FirebaseUser>();

  Stream<String> get uidStream { 
    return _userSubject.where((x) => x != null).map((x) => x.uid);
  }

  Stream<bool> get isAuthenticated {
    return _userSubject.stream.map((x) => x != null);
  }

  String get uid {
    return _userSubject.value?.uid;
  }

  factory AuthService() {
    if(_instance == null) _instance = AuthService._();
    return _instance;
  }

  AuthService._() {
    _userSubject.addStream(_auth.onAuthStateChanged);
  }

  Future<String> signInAnonymously() async {
    final user = await _auth.signInAnonymously();
    FirebaseAnalytics().logLogin();
    return user.uid;
  }

  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final user = await _auth.signInWithCredential(credential);
    FirebaseAnalytics().logLogin();
    return user.uid;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}