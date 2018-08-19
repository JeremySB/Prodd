import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:prodd/models/goal.dart';

class GoalRepository {
  GoalRepository()
      : _db = Firestore.instance,
        _analytics = FirebaseAnalytics(),
        _uid = "jeremy" {
    _userdoc = _db.collection(_usersCollection).document(_uid);
  }
  
  final Firestore _db;
  final String _uid;
  final FirebaseAnalytics _analytics;
  DocumentReference _userdoc;

  static const _usersCollection = "users";
  static const _goalsCollection = "goals";
  
  static const _titleField = "title";
  static const _completeByField = "completeBy";
  static const _statusField = "status";

  /// Returns a [Stream] of every [Goal] for user.
  Stream<List<Goal>> goalStream() {
    return _userdoc.collection(_goalsCollection).snapshots().map(_convertSnapshot);
  }

  /// Returns a [Stream] of every [Goal] with [Goal.status] == [GoalStatus.active].
  Stream<List<Goal>> activeGoalStream() {
    return _userdoc.collection(_goalsCollection).where(
      _statusField,
      isEqualTo: GoalStatus.active.index
    )
    .snapshots().map(_convertSnapshot);
  }

  /// Writes a [Goal] to the database. Creates a new record if [Goal.id] is null.
  Future<void> saveGoal(Goal goal) {
    final goalRef = _userdoc.collection(_goalsCollection).document(goal.id);
    final data = <String, dynamic>{
      _titleField: goal.title,
      _completeByField: goal.completeBy,
      _statusField: goal.status?.index ?? GoalStatus.active.index
    };
    return goalRef.setData(data, merge: false);
  }
  
  List<Goal> _convertSnapshot(QuerySnapshot qs) {
    return qs.documents.map((d) {
      try {
        final goal = Goal(
          id: d.documentID,
          title: d.data[_titleField], 
          completeBy: d.data[_completeByField],
          status: d.data[_statusField] != null ? GoalStatus.values[ d.data[_statusField] ] : null
        );
        return goal;
      } catch (e) {
        _analytics.logEvent(name: "parse_goal_error", parameters: {"error": e});
        return null;
      }
    }).whereType<Goal>().toList();
  }
}