import 'package:flutter/material.dart';

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
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RunTrackerPage()));
      },
      height: 130,
      flex: 5,
      color: Colors.white,
      child: Stack(
        children: [
          Align(
              alignment: Alignment.topLeft,
              child: Text("Run tracker", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: Colors.grey[600], ),)
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                    child: Icon(Icons.directions_run, color: Colors.grey[600], size: 40,),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
