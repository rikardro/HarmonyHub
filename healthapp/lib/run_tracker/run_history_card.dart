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
        const SizedBox(
          width: 20,
        ),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ],
    );
  }

  
  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      flex: 0,
      color: const Color(0xbb0000000),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(history.dayName,
                    style:const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,
                    )),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text(history.duration,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 26,
                          color: Colors.orangeAccent,
                        )),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text("min",
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
                  children: const [
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
                const SizedBox(
                  width: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      history.avgMinPerKm,
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    Text(
                      "${history.distance} km",
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    Text(
                      "${history.avgKmPerHour} m/s",
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
