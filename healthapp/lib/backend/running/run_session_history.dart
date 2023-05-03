import 'package:cloud_firestore/cloud_firestore.dart';

import '../location/location_search.dart';

class RunSessionHistory {
  String? userId;
  String? id;
  DateTime startTime;
  String duration;
  String distance;
  String avgMinPerKm;
  String avgKmPerHour;

  RunSessionHistory({
    required this.userId,
    required this.id,
    required this.startTime,
    required this.duration,
    required this.distance,
    required this.avgMinPerKm,
    required this.avgKmPerHour
  });

  static fromFirestore(QueryDocumentSnapshot<Object?> doc) {
    return RunSessionHistory(
      userId: doc['userId'],
      id: doc.id,
      startTime: doc['startTime'].toDate(),
      duration: doc['duration'],
      distance: doc['distance'],
      avgMinPerKm: doc['avgMinPerKm'],
      avgKmPerHour: doc['avgKmPerH']
    );
  }

}
