import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class Caffeine {
  final String id;
  //final String userId;
  final double amount;
  //final String status;
  final Timestamp timestamp;

  Caffeine({required this.id, required this.timestamp, required this.amount});

  static Caffeine fromFirestore(QueryDocumentSnapshot<Object?> doc) {
    // TODO: NULL CHECK!
    // TODO: fix status?

    log(doc.data().toString());

    /* final caffeine = Caffeine(
      id: doc.id,
      //id: "XXX",
      amount: doc['amountConsumed'] as double,
      timestamp: doc['timeConsumed'] as Timestamp,
      //TODO change this to dynmically set status from {"high", "medium", "low}
      //status: "High",
    ); */

    final caffeine = Caffeine(
        id: "XXX", timestamp: Timestamp.fromDate(DateTime.now()), amount: 5000);
 
    log(caffeine.toString());
    return caffeine;
  }

  @override
  String toString() {
    return 'Caffeine { amount: $amount, timestamp: $timestamp }';
  }
}
