import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RunningPreferences extends StatefulWidget {
  const RunningPreferences({Key? key}) : super(key: key);

  @override
  _RunningPreferencesState createState() => _RunningPreferencesState();
}


class _RunningPreferencesState extends State<RunningPreferences> {
  double _preferredTemperature = 20.0;
  double _preferredPrecipitation = 50.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Preferences", style: TextStyle(fontSize: 18.0)),
          SizedBox(height: 16.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
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
                    _preferredTemperature.round().toString() + "°C",
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Preferred Precipitation",
                style: TextStyle(fontSize: 16.0),
              ),
              Row(
                children: [
                  Expanded(
                    child: Slider(
                      value: _preferredPrecipitation,
                      min: 0,
                      max: 100,
                      divisions: 100,
                      label: _preferredPrecipitation.round().toString(),
                      onChanged: (value) {
                        setState(() {
                          _preferredPrecipitation = value;
                        });
                      },
                    ),
                  ),
                  Text(
                    _preferredPrecipitation.round().toString() + "%",
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              // Save the preferences and close the bottom sheet
              Navigator.pop(context);
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }
}
