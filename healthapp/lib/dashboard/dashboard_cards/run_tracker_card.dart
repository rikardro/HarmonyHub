import 'package:flutter/material.dart';
import 'package:healthapp/run_tracker/run_history_page.dart';

import '../../run_tracker/run_tracker_page.dart';
import '../dashboard_card.dart';

class RunTrackerCard extends StatefulWidget {
  const RunTrackerCard({Key? key}) : super(key: key);

  @override
  State<RunTrackerCard> createState() => _RunTrackerCardState();
}

class _RunTrackerCardState extends State<RunTrackerCard> {
  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RunHistoryPage()),
        );
      },
      flex: 5,
      color: Color(0xFF0C4C4D),
      child: Column(
        children: [
          Text(
            "Run Tracker",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
              Icon(
                Icons.directions_run,
                color: Colors.white,
                size: 30,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
