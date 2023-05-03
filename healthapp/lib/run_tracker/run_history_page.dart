import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthapp/run_tracker/run_history_card.dart';
import 'package:healthapp/run_tracker/run_tracker_page.dart';

import '../bloc/run_history_bloc.dart';
import '../dashboard/gradientColor.dart';

class RunHistoryPage extends StatefulWidget {
  const RunHistoryPage({Key? key}) : super(key: key);

  @override
  State<RunHistoryPage> createState() => _RunHistoryPageState();
}

class _RunHistoryPageState extends State<RunHistoryPage> {
  Widget newRunBtn() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RunTrackerPage()),
        );
      },
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // add gradient color
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: GradientColor.getGradient(Colors.deepOrange.value),
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
          Icons.add,
          color: Colors.white,
          size: 50,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.read<RunHistoryBloc>().add(FetchRunHistory());
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          // history here
          Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Run tracker",
                  style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 26,
                      fontWeight: FontWeight.w500),
                ),
              )),
          Expanded(child: BlocBuilder<RunHistoryBloc, RunHistoryState>(
            builder: (context, state) {
              final histori = state.runHistory;
              if (state.status == RunHistoryStatus.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return SingleChildScrollView(
                  child: Column(
                      children: histori
                          .map((e) => RunHistoryCard(history: e))
                          .toList()),
                );
              }
            },
          )),
          Center(
              child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: newRunBtn(),
          ))
        ],
      ),
    );
  }
}
