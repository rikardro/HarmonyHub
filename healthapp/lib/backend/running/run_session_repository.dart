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

  String twoDigits(int? n){
    if(n == null) return "--";
    return n.toString().padLeft(2, "0");
  }

  /// Adds a new caffeine consumption to the database
  Future<void> addRunSession(RunSession session) async {
    try {
      await instance.add({
        'userId': provider.currentUser?.id,
        'avgKmPerH': session.getAvgKmPerHour().toStringAsFixed(2),
        'avgMinPerKm': session.getAvgMinPerKm().toStringAsFixed(2),
        'distance': session.getDistance().toStringAsFixed(2),
        'duration': "${twoDigits(session.duration.inMinutes.remainder(60))}:${twoDigits(session.duration.inSeconds.remainder(60))}",
        'startTime': DateTime.now()
      });
    } catch (e) {
      print(e);
      print("FIREBASE ERROR");
    }
  }

  Future<List<RunSessionHistory>> fetchAllRunSessions() async {
    print("FETCH ALL RUN SESSIONS");
    // get the users id
    final currentUserId = provider.currentUser?.id;
    final QuerySnapshot querySnapshot =
        await instance.where('userId', isEqualTo: currentUserId).get();

    List<RunSessionHistory> runSessions = [];

    for (QueryDocumentSnapshot<Object?> doc in querySnapshot.docs) {
      final session = RunSessionHistory.fromFirestore(doc);
      runSessions.add(session);
    }

    // Sort the caffeineList based on the timeConsumed field
    runSessions.sort((a, b) => b.startTime.compareTo(a.startTime));

    return runSessions;
  }
}
