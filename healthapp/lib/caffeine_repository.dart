import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthapp/caffeine_detailed_view.dart';
import 'package:healthapp/services/auth/auth/firebase_auth_provider.dart';
import 'dart:math' as math;
import 'caffeine.dart';

class CaffeineRepository {
  //TODO: should be in constructor instead?
  final FirebaseAuthProvider provider = FirebaseAuthProvider();

  //TODO: this should be broken out into DataSource with its interface!
  final CollectionReference instance =
      FirebaseFirestore.instance.collection('ConsumptionHistory');

  /// Returns the current caffeine level
  Future<Caffeine> fetchCurrentCaffeine() async {
    final today = DateTime.now();
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    final startOfYesterday = Timestamp.fromDate(
        DateTime(yesterday.year, yesterday.month, yesterday.day, 0, 0, 0, 0, 0));

    final endOfToday = Timestamp.fromDate(
        DateTime(today.year, today.month, today.day, 23, 59, 59, 999, 999));

    final currentUserId = provider.currentUser?.id;
    if (currentUserId == null) {
      // Handle the case where the user is not logged in
      //TODO: is there a better way to handle this?
      return Caffeine(amount: 0, status: "Low");
    }

    /// Get all the caffeine consumed today
    final QuerySnapshot querySnapshot = await instance
        .where('userId', isEqualTo: currentUserId)
        .where('timeConsumed', isGreaterThanOrEqualTo: startOfYesterday)
        .where('timeConsumed', isLessThanOrEqualTo: endOfToday)
        .get();

    final total = getTotalCaffeine(querySnapshot);
    final status = _getStatus(total);

    return Caffeine(amount: total, status: status);
  }

  /// Returns the status of the caffeine level.
  /// This is calculated by taking the total amount of caffeine consumed today
  /// and comparing it to the thresholds.
  String _getStatus(double total) {
    String status;

    if (total < 50) {
      status = "Low";
    } else if (total >= 50 && total < 200) {
      status = "Medium";
    } else if (total >= 200) {
      status = "High";
    } else {
      status = "Error";
    }

    return status;
  }

  /// Returns the total amount of caffeine consumed today.
  /// This is calculated by taking the amount of caffeine consumed and
  /// using the half life formula to calculate the amount of caffeine in the body.
  double getTotalCaffeine(QuerySnapshot<Object?> snapshot) {
    double total = 0;
    for (QueryDocumentSnapshot<Object?> doc in snapshot.docs) {
      final secondElapsed = doc['timeConsumed'].seconds.toDouble();

      final amountCaffeine = doc['amountConsumed'];

      DateTime currentTime = DateTime.now();
      DateTime storedTime =
          DateTime.fromMillisecondsSinceEpoch(secondElapsed.toInt() * 1000);

      Duration timePassed = currentTime.difference(storedTime);

      int secondsPassed = timePassed.inSeconds + 1;

      final numberOfHalfs = (secondsPassed / (5 * 60 * 60));

      total += amountCaffeine * math.pow(0.5, numberOfHalfs);
    }

    return total;
  }

  /// Adds a new caffeine consumption to the database
  Future<void> addConsumedCaffeine(
      double caffeineLevel, String drinkType, double timeSince) async {
    try {
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      final timeConsumed = currentTime - (timeSince * 3600000).floor();
      await FirebaseFirestore.instance.collection('ConsumptionHistory').add({
        'userId': provider.currentUser?.id,
        'amountConsumed': caffeineLevel,
        'timeConsumed': Timestamp.fromMillisecondsSinceEpoch(timeConsumed),
        'drinkType': drinkType,
      });
    } catch (e) {
      print('Error adding document: $e');
    }
  }

  Future<List<CaffeineRecord>> fetchAllCaffeine() async {
    final currentUserId = provider.currentUser?.id;
    final QuerySnapshot querySnapshot =
        await instance.where('userId', isEqualTo: currentUserId).get();

    List<CaffeineRecord> caffeineList = [];

    for (QueryDocumentSnapshot<Object?> doc in querySnapshot.docs) {
      CaffeineRecord caffeine = CaffeineRecord(
        id: doc.id,
        product: doc['drinkType'],
        caffeineAmount: doc['amountConsumed'],
        timeConsumed: doc['timeConsumed'],
      );
      caffeineList.add(caffeine);
    }

    // Sort the caffeineList based on the timeConsumed field
    caffeineList.sort((a, b) => b.timeConsumed.compareTo(a.timeConsumed));

    return caffeineList;
  }


  Future<void> deleteCaffeine(String docRef) async{
    await instance.doc(docRef).delete();
  }
}
