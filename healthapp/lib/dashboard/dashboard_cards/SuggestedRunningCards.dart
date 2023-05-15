import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/running_bloc.dart';
import 'suggested_running_card.dart';

class SuggestedRunningCards extends StatefulWidget {
  @override
  _SuggestedRunningCardsState createState() => _SuggestedRunningCardsState();
}

class _SuggestedRunningCardsState extends State<SuggestedRunningCards> {
  int _displayCount = 3;

  void _loadMore() {
    setState(() {
      _displayCount += 7;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RunningBloc, RunningState>(
      builder: (context, state) {
        if (state.status == RunningStatus.loading) {
          _displayCount = 3;
          return const CircularProgressIndicator();
        } else {
          final recommended = state.intervals ?? [];
          final displayed = recommended.take(_displayCount).toList();
          return Column(
            children: [
              ...displayed.map((e) => SuggestedRunningCard(interval: e)),
              if (displayed.length < recommended.length)
                ElevatedButton(
                  onPressed: _loadMore,
                  child: const Text('Load More'),
                ),
            ],
          );
        }});
     
      }
}