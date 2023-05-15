import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../location/location_search.dart';

class RunSessionHistory {
  String? userId;
  String? id;
  DateTime startTime;
  String duration;
  String distance;
  String avgMinPerKm;
  String avgKmPerHour;
  String dayName;

  RunSessionHistory({
    required this.userId,
    required this.id,
    required this.startTime,
    required this.duration,
    required this.distance,
    required this.avgMinPerKm,
    required this.avgKmPerHour,
  }) : dayName = formatDate(startTime);

  static RunSessionHistory fromFirestore(QueryDocumentSnapshot<Object?> doc) {
    return RunSessionHistory(
      userId: doc['userId'],
      id: doc.id,
      startTime: doc['startTime'].toDate(),
      duration: doc['duration'],
      distance: doc['distance'],
      avgMinPerKm: doc['avgMinPerKm'],
      avgKmPerHour: doc['avgKmPerH'],
    );
  }

  static  String formatDate(DateTime time) {
    final DateFormat format = DateFormat('EEEE');
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    String dayName;
    if (time.day == now.day &&
        time.month == now.month &&
        time.year == now.year) {
      dayName = "Today";
    } else if (time.day == yesterday.day &&
        time.month == yesterday.month &&
        time.year == yesterday.year) {
      dayName = "Yesterday";
    } else {
      dayName = "${format.format(time)} (${DateFormat('d/M').format(time)})";
    }
    return dayName;
  }

}
