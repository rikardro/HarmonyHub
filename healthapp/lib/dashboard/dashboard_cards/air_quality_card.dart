import 'package:flutter/material.dart';
import '../dashboard_card.dart';

class AirQualityCard extends StatelessWidget {
  const AirQualityCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      flex: 5, color: Colors.grey,
      child: Container(), // CONTENT HERE
    );
  }
}
