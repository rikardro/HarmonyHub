import 'package:flutter/material.dart';
import 'package:healthapp/backend/running/run_session_history.dart';
import 'package:intl/intl.dart';
import '../dashboard/dashboard_card.dart';

class RunHistoryCard extends StatelessWidget {
  final RunSessionHistory history;

  const RunHistoryCard({Key? key, required this.history}) : super(key: key);

  Widget statBox(IconData icon, String value) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
        SizedBox(
          width: 20,
        ),
        Text(
          value,
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ],
    );
  }

  // TODO, sholdn't be here lol
  String formatDate(DateTime time) {
    final DateFormat format = DateFormat('EEEE');
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    String dayName;
    if (time.day == now.day &&
        time.month == now.month &&
        time.year == now.year) {
      dayName = "Today";
    } else if (time.day == tomorrow.day &&
        time.month == tomorrow.month &&
        time.year == tomorrow.year) {
      dayName = "Tomorrow";
    } else {
      dayName = "${format.format(time)} (${DateFormat('d/M').format(time)})";
    }
    return dayName;
  }

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      flex: 0,
      color: Color(0xBB0000000),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(formatDate(history.startTime),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,
                    )),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text(history.duration,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 26,
                          color: Colors.orangeAccent,
                        )),
                    SizedBox(
                      width: 5,
                    ),
                    Text("min",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                          color: Colors.orangeAccent,
                        )),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.av_timer,
                      color: Colors.white,
                      size: 24,
                    ),
                    Icon(
                      Icons.directions_run,
                      color: Colors.white,
                      size: 24,
                    ),
                    Icon(
                      Icons.speed,
                      color: Colors.white,
                      size: 24,
                    ),
                  ],
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      history.avgMinPerKm,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    Text(
                      "${history.distance} km",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    Text(
                      "${history.avgKmPerHour} m/s",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ), // CONTENT HERE
    );
  }
}
