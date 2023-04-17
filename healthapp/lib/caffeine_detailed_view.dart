import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthapp/bloc/caffeine_bloc.dart';

class CaffeineDetailedView extends StatefulWidget {
  const CaffeineDetailedView({super.key});

  @override
  State<CaffeineDetailedView> createState() => _CaffeineDetailedViewState();
}

class _CaffeineDetailedViewState extends State<CaffeineDetailedView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Caffeine"),
        backgroundColor: Colors.purple,
      ),
      backgroundColor: Color(0xFF8D3786),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 25),
              child: Column(
                children: const [
                  Text(
                    "Your caffeine level",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "250 mg",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white),
                  ),
                  Text(
                    "High",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                log("Adding caffeine");
                //TODO: Why does this not work?
                context.read<CaffeineBloc>().add(
                      AddCaffeine(amount: 50.0, drinkType: "Kaffe"),
                    );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text("Add consumed drink",
                    style: TextStyle(color: Colors.black)),
              ),
            ),
            SizedBox(height: 30),
            Text(
              "Consumption history",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            Expanded(child: CaffeineList())
          ],
        ),
      ),
    );
  }
}

class CaffeineList extends StatelessWidget {
  const CaffeineList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: listCards.length,
      itemBuilder: (BuildContext context, int index) {
        final timeConsumed = listCards[index].timeConsumed.toDate();
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final yesterday = DateTime(now.year, now.month, now.day - 1);
        String dateText;
        if (timeConsumed.isAfter(today)) {
          dateText = "TODAY " +
              timeConsumed.hour.toString().padLeft(2, '0') +
              ":" +
              timeConsumed.minute.toString().padLeft(2, '0');
        } else if (timeConsumed.isAfter(yesterday)) {
          dateText = "YESTERDAY " +
              timeConsumed.hour.toString().padLeft(2, '0') +
              ":" +
              timeConsumed.minute.toString().padLeft(2, '0');
        } else {
          dateText = timeConsumed.day.toString().padLeft(2, '0') +
              "/" +
              timeConsumed.month.toString().padLeft(2, '0') +
              "/" +
              timeConsumed.year.toString() +
              " " +
              timeConsumed.hour.toString().padLeft(2, '0') +
              ":" +
              timeConsumed.minute.toString().padLeft(2, '0');
        }
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(listCards[index].product),
                  SizedBox(width: 10),
                  Text('${listCards[index].caffeineAmount} mg'),
                  SizedBox(width: 10),
                  Text(dateText),
                ],
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {},
              ),
            ],
          ),
        );
      },
    );
  }
}

List<CaffeineRecord> listCards = [
  CaffeineRecord(
      product: "Kaffe",
      caffeineAmount: 50,
      timeConsumed: Timestamp.fromDate(DateTime.now())),
];

class CaffeineRecord {
  final String product;
  final int caffeineAmount;
  final Timestamp timeConsumed;

  CaffeineRecord({
    required this.product,
    required this.caffeineAmount,
    required this.timeConsumed,
  });
}
