import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthapp/dashboard/gradientColor.dart';

import '../bloc/run_tracker_bloc.dart';

class RunTrackerPage extends StatefulWidget {
  const RunTrackerPage({Key? key}) : super(key: key);

  @override
  State<RunTrackerPage> createState() => _RunTrackerPageState();
}

class _RunTrackerPageState extends State<RunTrackerPage> {

  Widget statBox(IconData icon, String value, String subtitle){
    return Column(
      children: [
        Icon(icon, color: Colors.grey[700], size: 35,),
        Text(value, style: TextStyle(color: Colors.grey[700], fontSize: 26),),
        Text(subtitle, style: TextStyle(color: Colors.grey[500], fontSize: 18),)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RunTrackerBloc(),
      child: SafeArea(
        child: Material(
          color: Colors.grey[200],
          child: Center(
            child: BlocBuilder<RunTrackerBloc, RunTrackerState>(
               builder: (context, state) {
                  /*return InkWell(
                    onTap: (){
                      if(state.status == RunTrackerStatus.stopped)
                        context.read<RunTrackerBloc>().add(StartTracking());
                      else
                        context.read<RunTrackerBloc>().add(StopTracking());
                    },
                    child: Container(
                      width: 100,
                      height: 100,
                      color: state.status == RunTrackerStatus.running ? Colors.red : Colors.green,),
                    );
                   */
                 final height = MediaQuery.of(context).size.height;
                 return Stack(
                    children: [
                      Positioned(
                        top: -(height * 0.5),
                        left: -(height*0.3),
                        right: -(height*0.3),
                        child: Container(
                          width: height,
                          height: height,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/map.png',
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        // circle container
                        child: Container(
                          height: height*0.575,
                          child: BlocBuilder<RunTrackerBloc, RunTrackerState>(
                            builder: (context, state) {
                              print(state.runSession?.getDistance());
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    width: 120,
                                    height: 120,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color.fromRGBO(255, 255, 255, 0.9),
                                      // shadow
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 4,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text("${state.runSession?.duration.inMinutes ?? "--"}:${state.runSession?.duration.inSeconds ?? "--"}", style: TextStyle(color: Colors.grey[700], fontSize: 40),),
                                        Text("min", style: TextStyle(color: Colors.grey[500], fontSize: 20),)
                                      ],
                                    ),
                                  ),
                                  Row( // avg. min/km, distance and avg. speed
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      statBox(Icons.av_timer, state.runSession?.getAvgMinPerKm().toStringAsFixed(2).replaceFirst(".", ":") ?? "--:--", "Avg. min/km"),
                                      statBox(Icons.directions_run, "${state.runSession?.getDistance().toStringAsFixed(2) ?? "-"} km", "Distance"),
                                      statBox(Icons.speed, "${state.runSession?.getAvgKmPerHour().toStringAsFixed(1) ?? "-"} m/s", "Avg. speed")
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      state.runSession != null && state.status == RunTrackerStatus.paused ? Padding(
                                        padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                                        child: InkWell(
                                            onTap: (){
                                              if(state.status == RunTrackerStatus.paused){
                                                context.read<RunTrackerBloc>().add(StopTracking());
                                                Navigator.of(context).pop();
                                              }
                                            },
                                            child: actionBtn(65, Colors.red, Icons.stop)
                                        ),
                                      ) : Container(),
                                      InkWell(
                                          onTap: (){
                                            if(state.status == RunTrackerStatus.stopped){
                                              context.read<RunTrackerBloc>().add(StartTracking());
                                            }
                                            else if(state.status == RunTrackerStatus.running){
                                              context.read<RunTrackerBloc>().add(PauseTracking());
                                            } else if(state.status == RunTrackerStatus.paused){
                                              context.read<RunTrackerBloc>().add(ResumeTracking());
                                            }
                                          },
                                          child: state.status != RunTrackerStatus.running ? actionBtn(100, Colors.green, Icons.play_arrow) : actionBtn(100, Colors.blue, Icons.pause)
                                      ),

                                    ],
                                  )

                                ],
                              );
                             }

                          ),
                        ),
                      ),
                    ],
                 );
              },
            )
          ),
        ),
      ),
    );
  }

  Widget actionBtn(double size, Color color, IconData icon){
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
      child: Icon(icon, color: Colors.white, size: size/2,),
    );
  }
}
