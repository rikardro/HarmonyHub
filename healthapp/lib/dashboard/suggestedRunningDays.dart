import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthapp/dashboard/dashboard_cards/suggested_running_card.dart';
import 'package:healthapp/dashboard/running_preferences.dart';
import 'package:healthapp/util/weatherPreferences.dart';
import '../../bloc/running_bloc.dart';

class SuggestedRunningDays extends StatefulWidget {
  @override
  _SuggestedRunningCardsState createState() => _SuggestedRunningCardsState();
}

class _SuggestedRunningCardsState extends State<SuggestedRunningDays> {
  int _displayCount = 3;

  void _loadMore() {
    setState(() {
      _displayCount += 7;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(12, 16, 12, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Suggested running days",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      context.read<RunningBloc>().add(const FetchPreferences());
                      return BlocBuilder<RunningBloc, RunningState>(
                        builder: (context, state) {
                          if (state.status == RunningStatus.loading) {
                            return Container();
                          } else {
                            WeatherPreferences preference =
                                state.preferences ??
                                    WeatherPreferences(
                                      18,
                                      true,
                                      0,
                                      25,
                                      0,
                                      const TimeOfDay(hour: 4, minute: 59),
                                      const TimeOfDay(hour: 22, minute: 01),
                                    );
                            final temperature = preference.targetTemp;
                            final precipitation = preference.rainPref;
                            final cloudCoverage = preference.cloudPref;
                            final windSpeed = preference.windPref;
                            final snow = preference.avoidSnow;
                            final startTime = preference.startTime;
                            final endTime = preference.endTime;
                            return RunningPreferences(
                              temperature,
                              precipitation,
                              cloudCoverage,
                              windSpeed,
                              snow,
                              startTime,
                              endTime,
                            );
                          }
                        },
                      );
                    },
                  );
                },
                child: const Text("Preferences"),
              ),
            ],
          ),
        ),
        BlocBuilder<RunningBloc, RunningState>(
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
            }
          },
        ),
      ],
    );
  }
}
