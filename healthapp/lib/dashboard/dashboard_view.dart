import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthapp/dashboard/dashboard_cards/air_quality_card.dart';
import 'package:healthapp/dashboard/dashboard_cards/caffeine_card.dart';
import 'package:healthapp/dashboard/dashboard_cards/health_card.dart';
import 'package:healthapp/dashboard/dashboard_cards/weather_card.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [WeatherCard(), AirQualityCard()],
          ),
          Row(
            children: [
              HealthCard(
                title: "Steps",
                value: "3457",
                icon: Icons.directions_walk,
                iconColor: Colors.grey[600],
              ),
              const HealthCard(
                  title: "Heart",
                  value: "69",
                  icon: Icons.favorite,
                  iconColor: Colors.red)
            ],
          ),
          Row(
            children: [
              HealthCard(
                flex: 5,
                height: 120,
                title: "Flights",
                value: "13",
                icon: Icons.stairs,
                iconColor: Colors.grey[600],
                topPadding: 24,
              ),
              CaffeineCard(
                caffeine: 50,
              )
            ],
          ),
        ],
      ),
    );
  }
}
