import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:healthapp/util/weatherPreferences.dart';

class RunningPreferences extends StatefulWidget {
  const RunningPreferences({Key? key}) : super(key: key);

  @override
  _RunningPreferencesState createState() => _RunningPreferencesState();
}

class _RunningPreferencesState extends State<RunningPreferences> {
  double _preferredTemperature = 18;
  double _preferredPrecipitation = 0;
  double _preferredCloudCoverage = 25;
  double _preferredWindSpeed = 0;
  bool _snowPreference = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Preferences", style: TextStyle(fontSize: 18.0)),
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
              // Save the preferences and close the bottom sheet
              WeatherPreferences preferences = WeatherPreferences(
                  _preferredTemperature,
                  _snowPreference,
                  _preferredPrecipitation,
                  _preferredCloudCoverage,
                  _preferredWindSpeed);
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
