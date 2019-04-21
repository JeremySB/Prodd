
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:prodd/data/auth_service.dart';
import 'package:rxdart/rxdart.dart';

class NotificationService {
  static const _usersCollection = "users";
  static const _notificationKeysCollection = "notificationKeys";

  static const _createdField = "created";

  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging();

  static NotificationService _instance;

  factory NotificationService() {
    if(_instance == null) _instance = NotificationService._();
    return _instance;
  }

  NotificationService._() {
    Observable.combineLatestList([AuthService().uidStream, _messaging.onTokenRefresh]).listen(_tokenRefreshHandler);
  }

  void _tokenRefreshHandler(List<String> uidTokenList) {
    final uid = uidTokenList[0];
    final token = uidTokenList[1];
    assert(uid != null && token != null);
    if (uid != null) {
      _db.collection(_usersCollection).document(uid).collection(_notificationKeysCollection).document(token).setData({
        _createdField: FieldValue.serverTimestamp()
      });
    }
  }
}