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

class AudioPlayerCard extends StatelessWidget {
  const AudioPlayerCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
        flex: 5,
        color: const Color(0xFFFA7DCA),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AudioPickerView(),
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "Music",
                style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 5),
              Icon(
                Icons.music_note_outlined,
                color: Colors.white,
                size: 40,
              )
            ],
          ),
        ));
  }
}
