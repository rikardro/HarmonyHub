import 'package:flutter/material.dart';
import 'package:healthapp/dashboard/dashboard_cards/air_quality_card.dart';
import 'package:healthapp/dashboard/dashboard_cards/caffeine_card.dart';
import 'package:healthapp/dashboard/dashboard_cards/health_card.dart';
import 'package:healthapp/dashboard/dashboard_cards/weather_card.dart';
import 'dashboard_card.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              WeatherCard(),
              AirQualityCard()
            ],
          ),
          Row(
            children: [
              HealthCard(),
              HealthCard()
            ],
          ),
          Row(
            children: [
              HealthCard(flex: 5, height: 120,),
              CaffeineCard()
            ],
          ),
        ],
      ),
    );
  }
}
