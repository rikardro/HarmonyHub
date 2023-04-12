import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthapp/dashboard/dashboard_cards/air_quality_card.dart';
import 'package:healthapp/dashboard/dashboard_cards/caffeine_card.dart';
import 'package:healthapp/dashboard/dashboard_cards/health_card.dart';
import 'package:healthapp/dashboard/dashboard_cards/weather_card.dart';

class DashboardView extends StatelessWidget {
  DashboardView({Key? key}) : super(key: key);

  final topTextStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey[600]);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Välkommen!", style: topTextStyle,),
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.grey[600],),
                    Text("Göteborg", style: topTextStyle)
                  ],
                )
              ],
            ),
          ),
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
