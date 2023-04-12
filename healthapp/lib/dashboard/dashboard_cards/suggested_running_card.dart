import 'package:flutter/material.dart';

import '../dashboard_card.dart';

class SuggestedRunningCard extends StatelessWidget {
  const SuggestedRunningCard({Key? key}) : super(key: key);

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
                Text("Wednesday", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: Colors.grey[600])),
                Text("13:00 - 20:00", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.grey[600])),
                SizedBox(height: 10,),
                Text("Sunny 19°C", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: Colors.orangeAccent)),
              ],
            ),
            Icon(Icons.sunny, color: Colors.orangeAccent, size: 40,)
          ],
        ),
      ), // CONTENT HERE
    );
  }
}
