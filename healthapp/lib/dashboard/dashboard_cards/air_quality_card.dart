import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthapp/backend/location/location.dart';
import 'package:healthapp/util/dialogs/error_dialog.dart';
import 'package:healthapp/util/dialogs/information_dialog.dart';
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
      case ("okey"):
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
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              showInformationDialog(
                  context, "About weather quality", aqiInformation);
            },
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Air quality",
                    style: TextStyle(
                      shadows: [textShadow],
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    state.airQuality.toString(),
                    style: TextStyle(
                        shadows: [textShadow],
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0,
                        color: Colors.white),
                  ),
                  /* const Image(
                    image: AssetImage('assets/images/wind_white.png'),
                    width: 60,
                  ), */
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

const String aqiInformation = '''
AQI is a measure used to assess and communicate air pollution levels.

It considers pollutants such as PM2.5, PM10, O3, CO, SO2, and NO2.

AQI ranges from 0 to 500 or higher, indicating different air quality levels.

Categories and associated health risks:
- Good (0-50): Satisfactory air quality, minimal health risk.
- Moderate (51-100): Acceptable air quality, some moderate health concerns for sensitive individuals.
- Unhealthy for Sensitive Groups (101-150): Adverse effects on individuals with respiratory or heart conditions, children, and the elderly.
- Unhealthy (151-200): Considered unhealthy, everyone may experience some adverse health effects.
- Very Unhealthy (201-300): Significantly impaired air quality, increased health risks for the entire population.
- Hazardous (301-500): Extremely poor air quality, severe health impacts, emergency conditions may be declared.

AQI varies based on location and available monitoring stations.
Local authorities provide real-time or periodic updates on the AQI to inform the public and advise precautions.
''';
