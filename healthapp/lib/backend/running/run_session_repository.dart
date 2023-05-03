import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthapp/backend/running/run_session.dart';
import 'package:healthapp/backend/running/run_session_history.dart';
import 'package:healthapp/caffeine_detailed_view.dart';
import 'package:healthapp/services/auth/auth/firebase_auth_provider.dart';
import 'dart:math' as math;

class RunSessionRepository {
  //TODO: should be in constructor instead?
  final FirebaseAuthProvider provider = FirebaseAuthProvider();

  //TODO: this should be broken out into DataSource with its interface!
  final CollectionReference instance =
      FirebaseFirestore.instance.collection('RunSessions');

  /// Adds a new caffeine consumption to the database
  Future<void> addRunSession(RunSession session) async {
    try {
      await FirebaseFirestore.instance.collection('ConsumptionHistory').add({
        'userId': provider.currentUser?.id,
        'avgKmPerH': session.getAvgKmPerHour,
        'avgMinPerKm': session.getAvgMinPerKm,
        'distance': session.getDistance,
        'duration': session.duration.inSeconds,
      });
    } catch (e) {
    }
  }

  Future<List<RunSession>> fetchAllRunSessions() async {
    // get the users id
    final currentUserId = provider.currentUser?.id;
    final QuerySnapshot querySnapshot =
        await instance.where('userId', isEqualTo: currentUserId).get();

    List<RunSession> runSessions = [];

    for (QueryDocumentSnapshot<Object?> doc in querySnapshot.docs) {
      final session = RunSessionHistory.fromFirestore(doc);
      runSessions.add(session);
    }

    // Sort the caffeineList based on the timeConsumed field
    runSessions.sort((a, b) => b.startTime.compareTo(a.startTime));

    return runSessions;
  }
}
