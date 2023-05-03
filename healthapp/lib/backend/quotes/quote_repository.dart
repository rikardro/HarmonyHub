import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class UserRepository {
  //TODO: should be in constructor instead?

  //TODO: this should be broken out into DataSource with its interface!
  final CollectionReference instance =
      FirebaseFirestore.instance.collection('InspirationalQuotes');

  Future<String> getQuote() async {
    int dayOfYear = _getDayOfYear(DateTime.now());

    // 50 is the number of quotes in the database
    dayOfYear = dayOfYear % 42;

    DocumentSnapshot<Object?> document =
        await instance.doc(dayOfYear.toString()).get();
    final data = document.data() as Map<String, dynamic>;
    Future<String> quote =
        data.containsKey('quote') ? data['quote'] : 'Fuck around find out!';
    return quote;
  }

  int _getDayOfYear(DateTime date) {
    int year = date.year;
    DateTime startOfYear = DateTime(year);
    int diff = date.difference(startOfYear).inDays;
    return diff + 1;
  }

}


const List<String> healthQuotes = [
  "Your body is your most priceless possession. Take care of it.",
  "The greatest wealth is health.",
  "Take care of your body. It's the only place you have to live.",
  "A healthy outside starts from the inside.",
  "The best six doctors anywhere and no one can deny it are sunshine, water, rest, air, exercise and diet.",
  "Health is a state of body. Wellness is a state of being.",
  "You can't enjoy wealth if you're not in good health.",
  "Investing in your health is the single best investment you can make in your life.",
  "Good health is not something we can buy. However, it can be an extremely valuable savings account.",
  "The first wealth is health.",
  "An apple a day keeps the doctor away.",
  "The groundwork for all happiness is good health.",
  "Let food be thy medicine and medicine be thy food.",
  "Healthy citizens are the greatest asset any country can have.",
  "A healthy attitude is contagious but don't wait to catch it from others. Be a carrier.",
  "Healthy habits are learned in the same way as unhealthy ones - through practice.",
  "To ensure good health: eat lightly, breathe deeply, live moderately, cultivate cheerfulness, and maintain an interest in life.",
  "Physical fitness is not only one of the most important keys to a healthy body, it is the basis of dynamic and creative intellectual activity.",
  "Eat healthily, sleep well, breathe deeply, move harmoniously.",
  "Health and cheerfulness naturally beget each other.",
  "Your health is what you make of it. Everything you do and think either adds to the vitality, energy and spirit you possess or takes away from it.",
  "Those who think they have no time for exercise will sooner or later have to find time for illness.",
  "The human body is the best picture of the human soul.",
  "You're in pretty good shape for the shape you are in.",
  "The secret of health for both mind and body is not to mourn for the past, not to worry about the future, or not to anticipate troubles, but to live in the present moment wisely and earnestly.",
  "The body is like a piano, and happiness is like music. It is needful to have the instrument in good order.",
  "To keep the body in good health is a duty... otherwise, we shall not be able to keep our mind strong and clear.",
  "Walking is the best possible exercise. Habituate yourself to walk very far.",
  "Physical fitness is not only one of the most important keys to a healthy body, it is the basis of dynamic and creative intellectual activity.",
  "Healthy citizens are the greatest asset any country can have.",
  "A healthy outside starts from the inside.",
  "A good laugh and a long sleep are the best cures in the doctor's book.",
  "Happiness is nothing more than good health and a bad memory.",
  "Health is a relationship between you and your body.",
  "Physical fitness can neither be achieved by wishful thinking nor outright purchase.",
  "It's never too early or too late to work towards being the healthiest you.",
  "The only bad workout is the one that didn't happen.",
  "What you eat in private will show up in public.",
  "Eat food, not too much, mostly plants.",
  "Don't wait for tomorrow, start today!",
  "It's not a diet, it's a lifestyle change.",
  "Sweat is just fat crying.",
];
