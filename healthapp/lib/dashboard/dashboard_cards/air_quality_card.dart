import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthapp/backend/location/location.dart';
import '../../bloc/air_quality_bloc.dart';
import '../dashboard_card.dart';

const Color lightBlue = Color(0xFF7EC9FF);

class AirQualityCard extends StatelessWidget {
  AirQualityCard({Key? key}) : super(key: key);

  final textShadow = Shadow(
    blurRadius: 10,
    offset: const Offset(2, 2),
    color: Colors.black.withOpacity(0.3),
  );

  List<Color> getQualityColor(String quality) {
    quality = quality.toLowerCase();
    switch (quality) {
      case ("good"):
        {
          return const [Color(0xFF05FF00), Color(0xFF00FFFF)];
        }
      case ("poor"):
        {
          return const [
            Color.fromARGB(255, 252, 94, 94),
            Color.fromARGB(255, 255, 141, 89)
          ];
        }
      case ("okay"):
        {
          return const [
            Color.fromARGB(255, 255, 184, 78),
            Color.fromARGB(255, 255, 237, 73)
          ];
        }

      default:
        return const [Color(0xFF05FF00), Color(0xFF00FFFF)];
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AirQualityBloc, AirQualityState>(
        builder: (context, state) {
      //final quality = getQualityColor(state.airQualityStatus ?? "");
      if (state.status == AirQualityStatus.success) {
        return DashboardCard(
          flex: 5,
          color: lightBlue,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Air quality",
                    style: TextStyle(
                        shadows: [textShadow],
                        color: Colors.white,
                        fontSize: 15)),
                const Image(
                  image: AssetImage('assets/images/wind_white.png'),
                  width: 60,
                ),
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: getQualityColor(state.airQualityStatus ?? ""),
                  ).createShader(bounds),
                  child: Text(
                    state.airQualityStatus ?? "",
                    style: TextStyle(
                      shadows: [textShadow],
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ), // CONTENT HERE
        );
      } else {
        return const DashboardCard(
            flex: 5,
            color: lightBlue,
            child: Center(child: CircularProgressIndicator()));
      }
    });
  }
}
