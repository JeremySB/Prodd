
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';


class AuthService {

  static final _instance = AuthService._();

  FirebaseUser _firebaseUser;

  Stream<String> get uid async* {
    var user = await FirebaseAuth.instance.currentUser();
    yield user?.uid;

    await for(var user in FirebaseAuth.instance.onAuthStateChanged) {
      yield user?.uid;
    }
  }

  factory AuthService() {
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