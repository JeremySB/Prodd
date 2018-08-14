import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prodd/models/goal.dart';

class GoalRepository {
  GoalRepository()
      : this._db = Firestore.instance,
        this._uid = "jeremy" {
    _userdoc = _db.collection(_usersCollection).document(_uid);
  }
  
  final Firestore _db;
  final String _uid;
  DocumentReference _userdoc;

  static const _usersCollection = "users";
  static const _goalsCollection = "goals";

  Stream<List<Goal>> goalStream() {
    return _userdoc.collection(_goalsCollection).snapshots().map<List<Goal>>((qs) {
       return qs.documents.map((d) {
        final goal = Goal(title: d.data["title"], completeBy: d.data["completeBy"]);
        return goal;
      }).toList();
    });
  }

  /// Writes a [Goal] to the database. Creates a new record if [Goal.id] is null.
  Future<void> saveGoal(Goal goal) {
    final goalRef = _userdoc.collection(_goalsCollection).document(goal.id);
    final data = <String, dynamic>{
      "title": goal.title,
      "completedBy": goal.completeBy
    };
    return goalRef.setData(data, merge: false);
  }
}