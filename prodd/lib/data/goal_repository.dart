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
    return _db.collection("users").document(_uid).collection("goals").snapshots().map<List<Goal>>((qs) {
       return qs.documents.map((d) { 
        final goal = Goal(title: d.data["title"], completeBy: d.data["completeBy"]);
        return goal;
      }).toList();
    });
  }
}