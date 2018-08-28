import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:prodd/models/change.dart';
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
  
  static const _titleField = "title",
               _completeByField = "completeBy",
               _statusField = "status",
               _estimatedDurationField = "estimatedDuration", 
               _beginNotificationsField = "beginNotifications";

  /// Returns a [Stream] of every [Goal] for user.
  Stream<List<Goal>> goalStream() {
    return _userdoc.collection(_goalsCollection).snapshots().map(_queryToGoals);
  }

  /// Returns a [Stream] of every [Goal] with [Goal.status] == [GoalStatus.active].
  Stream<List<Goal>> activeGoalStream() {
    return _userdoc.collection(_goalsCollection).where(
      _statusField,
      isEqualTo: GoalStatus.active.index
    )
    .snapshots().map(_queryToGoals);
  }

  /// Returns a [Stream] which has a list of [Change<Goal>]s. First result has everything currently there.
  Stream<List<Change<Goal>>> activeGoalChangesStream() {
    return _userdoc.collection(_goalsCollection).where(
      _statusField,
      isEqualTo: GoalStatus.active.index
    )
    .snapshots().map(_queryToGoalChanges);
  }

  /// Writes a [Goal] to the database. Creates a new record if [Goal.id] is null.
  Future<void> saveGoal(Goal goal) {
    final goalRef = _userdoc.collection(_goalsCollection).document(goal.id);
    final data = <String, dynamic>{
      _titleField: goal.title,
      _completeByField: goal.completeBy,
      _statusField: goal.status?.index ?? GoalStatus.active.index,
      _estimatedDurationField: goal.estimatedDuration?.inMinutes,
      _beginNotificationsField: goal.beginNotifications
    };
    return goalRef.setData(data, merge: false);
  }
  
  List<Goal> _queryToGoals(QuerySnapshot qs) {
    return qs.documents.map(_documentToGoal).whereType<Goal>().toList();
  }

  List<Change<Goal>> _queryToGoalChanges(QuerySnapshot qs) {
    var temp = qs.documentChanges.map((dc) => Change<Goal>(
      data: _documentToGoal(dc.document),
      type: dc.type == DocumentChangeType.added ? ChangeType.added 
                  : dc.type == DocumentChangeType.modified ? ChangeType.modified : ChangeType.removed,
      oldIndex: dc.oldIndex,
      newIndex: dc.newIndex,
    )).toList();
    return temp;
  }

  Goal _documentToGoal(DocumentSnapshot d) {
    try {
      final goal = Goal(
        id: d.documentID,
        title: d.data[_titleField], 
        completeBy: d.data[_completeByField],
        status: d.data[_statusField] != null ? GoalStatus.values[ d.data[_statusField] ] : null,
        estimatedDuration: d.data[_estimatedDurationField] != null ? Duration(minutes: d.data[_estimatedDurationField]) : null,
        beginNotifications: d.data[_beginNotificationsField]
      );
      return goal;
    } catch (e) {
      _analytics.logEvent(name: "parse_goal_error", parameters: {"error": e});
      return null;
    }
  }
}