import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthapp/audio_picker_view.dart';
import 'package:healthapp/bloc/caffeine_bloc.dart';
import 'package:healthapp/breathing_view.dart';
import 'package:healthapp/caffeine_repository.dart';
import '../../bloc/breathing_bloc.dart';
import '../../bloc/caffeine_detailed_bloc.dart';
import '../../bloc/quote_bloc.dart';
import '../../caffeine_detailed_view.dart';
import '../dashboard_card.dart';

class BreathingCard extends StatelessWidget {
  const BreathingCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
        flex: 1,
        color: const Color(0xFFFA7DCA),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AudioPickerView(),
              ),
            );
          },
          child: const Center(
            child: Text(
              "Meditation",
              style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ));
  }
}
