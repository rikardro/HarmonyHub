import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'dart:math';

class QuoteRepository {

  final CollectionReference instance;

  QuoteRepository() : instance = FirebaseFirestore.instance.collection('InspirationalQuotes');

  Future<String> getQuote() async {
    //there are 42 quotes in the database
    int random = Random().nextInt(42);

    DocumentSnapshot<Object?> document =
        await instance.doc(random.toString()).get();
    final data = document.data() as Map<String, dynamic>;
    String quote =
        data.containsKey('quote') ? data['quote'] : 'Fuck around find out!';
    return quote;
  }

}
