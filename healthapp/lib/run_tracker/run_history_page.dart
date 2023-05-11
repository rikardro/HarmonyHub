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
          MaterialPageRoute(
            builder: (context) => RunTrackerPage(),
          ),
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
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/park.png"),
            fit: BoxFit.fitHeight,
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            // history here
            Expanded(
              child: Stack(
                children: [
                  BlocBuilder<RunHistoryBloc, RunHistoryState>(
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
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: newRunBtn(),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
