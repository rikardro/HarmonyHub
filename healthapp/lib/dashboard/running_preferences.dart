import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthapp/bloc/running_bloc.dart';
import 'package:healthapp/util/weatherPreferences.dart';


class RunningPreferences extends StatefulWidget {
  late double temperature;
  late double precipitation;
  late double cloudCoverage;
  late double windSpeed;
  late bool snow;
  late TimeOfDay startTime;
  late TimeOfDay endTime;
  Function()? invalidTimeSnackbar;
  RunningPreferences(this.temperature, this.precipitation, this.cloudCoverage, this.windSpeed, this.snow, this.startTime, this.endTime, {Key? key}) : 
  super(key: key);

  @override
  _RunningPreferencesState createState() => _RunningPreferencesState(temperature, precipitation, cloudCoverage, windSpeed, snow, startTime, endTime);
}

class _RunningPreferencesState extends State<RunningPreferences> {
  double _preferredTemperature = 18;
  double _preferredPrecipitation = 0;
  double _preferredCloudCoverage = 25;
  double _preferredWindSpeed = 0;
  bool _snowPreference = true;
  TimeOfDay _startTime = const TimeOfDay(hour: 04, minute: 59);
  TimeOfDay _endTime = const TimeOfDay(hour: 22, minute: 01);
  
  _RunningPreferencesState(this._preferredTemperature, this._preferredPrecipitation, this._preferredCloudCoverage, this._preferredWindSpeed, this._snowPreference, this._startTime, this._endTime);

  showAlert(){
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Invalid time'),
        content: const Text('The start-time must be before the end-time'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

String formattedTimeOfDay(TimeOfDay timeOfDay) {
  final hour = timeOfDay.hour.toString().padLeft(2, '0');
  final minute = timeOfDay.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RunningBloc, RunningState>(
      builder: (context, state) {
        if (state.status == RunningStatus.loading) {
          return const CircularProgressIndicator();
        } else {
          return FractionallySizedBox(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Preferred Time of the day", style: TextStyle(fontSize: 16),),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () async {
                              final startTime = (await showTimePicker(
                                initialTime: _startTime,
                                context: context,
                                builder: (BuildContext context, Widget? child) {
                                  return MediaQuery(
                                    data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                                    child: child!,
                                  );
                                },
                              ))??_startTime;
                              if(startTime.hour < _endTime.hour){
                                _startTime = startTime;
                              }else{
                                showAlert();
                              }
                              setState(() {});
                            }, 
                            child: Text(formattedTimeOfDay(_startTime), style: const TextStyle(fontSize: 20))
                            ),
                            const Text("to", style: TextStyle(fontSize: 16)),
                            TextButton(
                              onPressed: () async {
                                final endTime = (await showTimePicker(
                                  initialTime: _endTime,
                                  context: context,
                                  builder: (BuildContext context, Widget? child) {
                                    return MediaQuery(
                                      data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                                      child: child!,
                                    );
                                  },
                                )) ?? _endTime;
                                if(endTime.hour > _startTime.hour){
                                  _endTime = endTime;
                                } else{
                                  showAlert();
                                }
                                setState(() {});
                              }, 
                              child: Text(formattedTimeOfDay(_endTime), style: const TextStyle(fontSize: 20))
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Preferred Temperature",
                        style: TextStyle(fontSize: 16.0),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Slider(
                              value: _preferredTemperature,
                              min: 0,
                              max: 40,
                              divisions: 40,
                              label: _preferredTemperature.round().toString(),
                              onChanged: (value) {
                                setState(() {
                                  _preferredTemperature = value;
                                });
                              },
                            ),
                          ),
                          Text(
                            "${_preferredTemperature.round()} °C",
                            style: const TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Preferred Cloud Coverage",
                        style: TextStyle(fontSize: 16.0),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Slider(
                              value: _preferredCloudCoverage,
                              min: 0,
                              max: 100,
                              divisions: 100,
                              label: _preferredCloudCoverage.round().toString(),
                              onChanged: (value) {
                                setState(() {
                                  _preferredCloudCoverage = value;
                                });
                              },
                            ),
                          ),
                          Text(
                            "${_preferredCloudCoverage.round()} %",
                            style: const TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Preferred Precipitation",
                        style: TextStyle(fontSize: 16.0),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Slider(
                              value: _preferredPrecipitation,
                              min: 0,
                              max: 20,
                              divisions: 20,
                              label: _preferredPrecipitation.round().toString(),
                              onChanged: (value) {
                                setState(() {
                                  _preferredPrecipitation = value;
                                });
                              },
                            ),
                          ),
                          Text(
                            "${_preferredPrecipitation.round()} mm",
                            style: const TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Preferred Wind Speed",
                        style: TextStyle(fontSize: 16.0),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Slider(
                              value: _preferredWindSpeed,
                              min: 0,
                              max: 20,
                              divisions: 20,
                              label: _preferredWindSpeed.round().toString(),
                              onChanged: (value) {
                                setState(() {
                                  _preferredWindSpeed = value;
                                });
                              },
                            ),
                          ),
                          Text(
                            "${_preferredWindSpeed.round()} m/s",
                            style: const TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Avoid snow",
                        style: TextStyle(fontSize: 16.0),
                      ),
                      Row(
                        children: [
                          Switch(
                            value: _snowPreference,
                            onChanged: (value) {
                              setState(() {
                                _snowPreference = value;
                              });
                            },
                            activeTrackColor: Colors.lightBlueAccent,
                            activeColor: Colors.blue,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<RunningBloc>(context).add(
                        SavePreferences(
                            _preferredTemperature,
                            _snowPreference,
                            _preferredPrecipitation,
                            _preferredCloudCoverage,
                            _preferredWindSpeed,
                            _startTime,
                            _endTime),
                      );
                      Navigator.pop(context);
                    },
                    child: const Text("Save"),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
