import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthapp/bloc/run_history_bloc.dart';
import 'package:healthapp/dashboard/gradientColor.dart';

import '../bloc/run_tracker_bloc.dart';

class RunTrackerPage extends StatefulWidget {
  const RunTrackerPage({Key? key}) : super(key: key);

  @override
  State<RunTrackerPage> createState() => _RunTrackerPageState();
}

class _RunTrackerPageState extends State<RunTrackerPage> {
  Widget statBox(IconData icon, String value, String subtitle) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 25,
        ),
        Text(
          value,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        Text(
          subtitle,
          style: TextStyle(color: Colors.white, fontSize: 13),
        )
      ],
    );
  }

  String twoDigits(int? n) {
    if (n == null) return "--";
    return n.toString().padLeft(2, "0");
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RunTrackerBloc(),
      child: Scaffold(
        backgroundColor: Color(0xFFAD76EC),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/runner.png"),
                fit: BoxFit.fitHeight,
              ),
            ),
            child: BlocBuilder<RunTrackerBloc, RunTrackerState>(
              builder: (context, state) {
                String minutes;
                String seconds;
                if (state.status == RunTrackerStatus.running ||
                    state.status == RunTrackerStatus.paused) {
                  minutes =
                      state.runSession!.getAvgMinPerKm().floor().toString();
                  seconds = twoDigits(
                          (state.runSession!.getAvgMinPerKm().remainder(1) * 60)
                              .round())
                      .toString();
                } else {
                  minutes = "--";
                  seconds = "--";
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 30),
                      color: Color.fromARGB(170, 29, 28, 28),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            width: 90,
                            height: 90,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${twoDigits(state.runSession?.duration.inMinutes.remainder(60))}:${twoDigits(state.runSession?.duration.inSeconds.remainder(60))}",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 30),
                                ),
                                Text(
                                  "min",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            // avg. min/km, distance and avg. speed
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              statBox(Icons.av_timer, '${minutes}:$seconds',
                                  "Avg. min/km"),
                              statBox(
                                  Icons.directions_run,
                                  "${state.runSession?.getDistance().toStringAsFixed(2) ?? "-"} km",
                                  "Distance"),
                              statBox(
                                  Icons.speed,
                                  "${state.runSession?.getAvgKmPerHour().toStringAsFixed(1) ?? "-"} m/s",
                                  "Avg. speed")
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              state.runSession != null &&
                                      state.status == RunTrackerStatus.paused
                                  ? Padding(
                                      padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                                      child: InkWell(
                                          onTap: () {
                                            if (state.status ==
                                                RunTrackerStatus.paused) {
                                              context
                                                  .read<RunTrackerBloc>()
                                                  .add(StopTracking());
                                              context
                                                  .read<RunHistoryBloc>()
                                                  .add(FetchRunHistory());
                                              Navigator.of(context).pop();
                                            }
                                          },
                                          child: actionBtn(
                                              65, Colors.red, Icons.stop)),
                                    )
                                  : Container(),
                              InkWell(
                                  onTap: () {
                                    if (state.status ==
                                        RunTrackerStatus.stopped) {
                                      context
                                          .read<RunTrackerBloc>()
                                          .add(StartTracking());
                                    } else if (state.status ==
                                        RunTrackerStatus.running) {
                                      context
                                          .read<RunTrackerBloc>()
                                          .add(PauseTracking());
                                    } else if (state.status ==
                                        RunTrackerStatus.paused) {
                                      context
                                          .read<RunTrackerBloc>()
                                          .add(ResumeTracking());
                                    }
                                  },
                                  child: state.status !=
                                          RunTrackerStatus.running
                                      ? actionBtn(
                                          100, Colors.green, Icons.play_arrow)
                                      : actionBtn(
                                          100, Colors.blue, Icons.pause)),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                );
              },
            )),
      ),
    );
  }

  Widget actionBtn(double size, Color color, IconData icon) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // add gradient color
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: GradientColor.getGradient(color.value),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: size / 2,
      ),
    );
  }
}
