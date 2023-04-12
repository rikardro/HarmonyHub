import 'package:flutter/material.dart';
import '../dashboard_card.dart';

class HealthCard extends StatelessWidget {
  const HealthCard({Key? key, this.height = 100, this.flex = 1}) : super(key: key);
  final double? height;
  final int? flex;

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      height: height,
      flex: flex, color: Colors.grey,
      child: Container(), // CONTENT HERE
    );
  }
}
