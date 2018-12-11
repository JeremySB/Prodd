
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';


class AuthService {

  static AuthService _instance;

  FirebaseUser _firebaseUser;

  String get lastUid => _firebaseUser?.uid;

  Stream<String> get uid async* {
    await for(var user in FirebaseAuth.instance.onAuthStateChanged) {
      print("auth state: " + user?.uid);
      yield user?.uid;
    }
  }

  factory AuthService() {
    if(_instance == null) _instance = AuthService._();
    return _instance;
  }

  AuthService._() {
    FirebaseAuth.instance.currentUser().then((user) {
      if(user == null) {
        FirebaseAuth.instance.signInAnonymously().then((user2) => _firebaseUser = user)
        .catchError((error) => print("Error" + error.error));
      } else {
        _firebaseUser = user;
      }
    });

    FirebaseAuth.instance.onAuthStateChanged.listen((user) => _firebaseUser = user);
  }
}