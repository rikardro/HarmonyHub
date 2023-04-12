import 'package:flutter/material.dart';
import '../dashboard_card.dart';

class WeatherCard extends StatelessWidget {
  const WeatherCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      flex: 12, color: Colors.grey,
      child: Container(), // CONTENT HERE
    );
  }
}
