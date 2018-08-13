import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prodd/models/goal.dart';

class GoalRepository {
  GoalRepository()
    : this._db = Firestore.instance,
      this._uid = "jeremy";
  
  final Firestore _db;
  final _uid;

  Stream<List<Goal>> goalStream() {
    return Firestore.instance.collection("users").document(_uid).collection("goals").snapshots().map((qs) {
      qs.documents.where((d) => d.exists).map((d) {
        return Goal(title: d.data["title"], completeBy: d.data["completeBy"]);
      });
    });
  }
}