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
      color: Color.fromARGB(255, 49, 204, 207),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Run Tracker",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          SizedBox(
            height: 10,
          ),
          Icon(
            Icons.timer_rounded,
            color: Colors.white,
            size: 40,
          ),
        ],
      ),
    );
  }
}
