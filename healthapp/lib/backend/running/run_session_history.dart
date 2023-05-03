import 'package:cloud_firestore/cloud_firestore.dart';

import '../location/location_search.dart';

class RunSessionHistory {
  String? userId;
  String? id;
  DateTime startTime;
  Duration duration;
  List<LocationData> path;
  double distance;
  double avgMinPerKm;
  double avgKmPerHour;

  RunSessionHistory({
    required this.userId,
    required this.id,
    required this.startTime,
    required this.duration,
    required this.path,
    required this.distance,
    required this.avgMinPerKm,
    required this.avgKmPerHour
  });

  static fromFirestore(QueryDocumentSnapshot<Object?> doc) {
    return RunSessionHistory(
      userId: doc['userId'],
      id: doc.id,
      startTime: doc['startTime'].toDate(),
      duration: Duration(seconds: doc['duration']),
      path: doc['path'].map<LocationData>((e) => LocationData.fromJson(e)).toList(),
      distance: doc['distance'],
      avgMinPerKm: doc['avgMinPerKm'],
      avgKmPerHour: doc['avgKmPerHour']
    );
  }

}
