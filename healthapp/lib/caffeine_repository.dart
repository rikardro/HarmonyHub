import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'caffeine.dart';

import 'dart:developer';

class CaffeineRepository {
  final CollectionReference instance =
      FirebaseFirestore.instance.collection('ConsumptionHistory');

  Future<Caffeine> fetchCurrentCaffeine() async {
    //log("hej");
    return Caffeine(
        id: "XXX", amount: 40, timestamp: Timestamp.fromDate(DateTime.now()));
  }

  Future<List<Caffeine>> fetchCaffeineConsumedToday() async {
    final today = DateTime.now();
    final startOfToday = Timestamp.fromDate(
        DateTime(today.year, today.month, today.day, 0, 0, 0, 0, 0));

    //log(startOfToday.toString());
    final endOfToday = Timestamp.fromDate(
        DateTime(today.year, today.month, today.day, 23, 59, 59, 999, 999));

    // TODO: fix so only fetch currect users data
    final QuerySnapshot querySnapshot = await instance
        /* .where('timestamp', isGreaterThanOrEqualTo: startOfToday)
        .where('timestamp', isLessThanOrEqualTo: endOfToday) */
        .get();

    //log(querySnapshot.size.toString());
    log("hejsan");

    final List<dynamic> caffeineList =
        querySnapshot.docs.map((doc) => Caffeine.fromFirestore(doc)).toList();

    log("kommer hit?"); //nej
    log('caffeineList: $caffeineList');

    // TODO: crashes here?
    return caffeineList as List<Caffeine>;
  }

  //TODO: change this!
  /* Future<void> addConsumedCaffeine(String userId, int caffeineLevel) async {
    try {
      await FirebaseFirestore.instance.collection('ConsumptionHistory').add({
        'userId': userId,
        'caffeineLevel': caffeineLevel,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print('Document added successfully!');
    } catch (e) {
      print('Error adding document: $e');
    }
  } */
}
