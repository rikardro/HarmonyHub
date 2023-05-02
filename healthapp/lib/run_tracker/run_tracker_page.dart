import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/run_tracker_bloc.dart';


class RunTrackerPage extends StatefulWidget {
  const RunTrackerPage({Key? key}) : super(key: key);

  @override
  State<RunTrackerPage> createState() => _RunTrackerPageState();
}

class _RunTrackerPageState extends State<RunTrackerPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RunTrackerBloc(),
      child: SafeArea(
        child: Material(
          child: Center(
            child: BlocBuilder<RunTrackerBloc, RunTrackerState>(
               builder: (context, state) {
                  return InkWell(
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
                  },
            )
          ),
        ),
      ),
    );
  }
}
