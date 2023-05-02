import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RunningPreferences extends StatefulWidget {
  const RunningPreferences({Key? key}) : super(key: key);

  @override
  _RunningPreferencesState createState() => _RunningPreferencesState();
}

class _RunningPreferencesState extends State<RunningPreferences>{
  double _preferredTemperature = 0;
  double  _preferredPrecipitation = 0;
  
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
          Text("Preferred temperature"),
          Slider(
            value: _preferredTemperature,
            min: 0,
            max: 100,
            onChanged: (value) {
              setState(() {
                _preferredTemperature = value;
              });
            },
          ),
          Text("Preferred precipitation"),
          Slider(
            value: _preferredPrecipitation,
            min: 0,
            max: 100,
            onChanged: (value) {
              setState(() {
                _preferredPrecipitation = value;
              });
            },
          ),
          // Add additional sliders or inputs for other preferences
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
