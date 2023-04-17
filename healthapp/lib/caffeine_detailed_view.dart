import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

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
      backgroundColor: Colors.red,
      body: Center(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 25),
              color: Colors.blue,
              child: const Text(
                "Your caffeine level",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
