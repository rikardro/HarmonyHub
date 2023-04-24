import 'package:flutter/material.dart';
import 'package:healthapp/backend/weather/recommended_days_repo.dart';

import '../dashboard_card.dart';

class SuggestedRunningCard extends StatelessWidget {
  SuggestedRunningCard({Key? key, required this.interval}) : super(key: key);
  final RecommendedIntervals interval;

  final shadows = [
    Shadow(
      blurRadius: 15,
      offset: const Offset(2, 2),
      color: Colors.black.withOpacity(0.15),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      flex: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(interval.dayName, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: Colors.grey[600], shadows: shadows)),
                 SizedBox(height: 5,),
                Text(interval.interval, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.grey[600], shadows: shadows)),
                SizedBox(height: 10,),
                Text(interval.temperature, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: Colors.orangeAccent, shadows: shadows)),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("Wind: ${interval.windspeed}", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.grey[600], shadows: shadows)),
                Text("Rain: ${interval.precipitation}", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.grey[600], shadows: shadows)),
                SizedBox(height: 10,),
                Row(children: [
                  Icon(Icons.sunny, color: Colors.orangeAccent, size: 25,),
                  Icon(Icons.sunny, color: Colors.orangeAccent, size: 25,)
                ],)
              ],
            )
          ],
        ),
      ), // CONTENT HERE
    );
  }
}
