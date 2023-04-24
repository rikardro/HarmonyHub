import 'package:flutter/material.dart';

import 'package:healthapp/dashboard/dashboard_card.dart';
import 'package:healthapp/util/weatherInformation.dart';
import 'package:healthapp/util/weatherType.dart';

class WeeklyWeatherCard extends StatelessWidget {
  late WeatherInformationWeekly wi;
  late AssetImage weatherImage;
  late Color weatherColor;
  late String weather;

  WeeklyWeatherCard(WeatherInformationWeekly wi, {Key? key}) : super(key: key) {
    init(wi.weather.toShortString());
  }

  final shadows = [
    Shadow(
      blurRadius: 15,
      offset: const Offset(2, 2),
      color: Colors.black.withOpacity(0.15),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      flex: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Image(image: weatherImage, width: 80),
                Text(weather),
              ],
            ),
            Column(
              children: [
                Text(wi.maxTemperature.toString(), style: TextStyle(color: Colors.black)),
                Text(wi.minTemperature.toString(), style: TextStyle(color: Colors.grey))
              ],
            ),
            Column(
              children: [
                Text(wi.precipitation.toString())
              ],
            ),
            Column(
              children: [
                Text(wi.maxWindspeed.toString())
              ],
            )
          ],
        ),
      ), // CONTENT HERE
    );
  }
  
  init(String weather) {
    switch (weather) {
      case ("clear"):
        {
          this.weather = "Sunny";
          weatherImage = const AssetImage('assets/images/clear_day.png');
          weatherColor = const Color(0xFFFF9900);
          break;
        }
      case ("cloudy"):
        {
          this.weather = "Cloudy";
          weatherImage = const AssetImage('assets/images/cloudy.png');
          weatherColor = const Color.fromARGB(255, 152, 166, 182);
          break;
        }
      case ("foggy"):
        {
          this.weather = "Foggy";
          weatherImage = const AssetImage('assets/images/foggy.png');
          weatherColor = const Color.fromARGB(255, 194, 223, 255);
          break;
        }
      case ("snowing"):
        {
          this.weather = "Snowing";
          weatherImage = const AssetImage('assets/images/snowing.png');
          weatherColor = const Color.fromARGB(255, 203, 210, 255);
          break;
        }
      case ("raining"):
        {
          this.weather = "Raining";
          weatherImage = const AssetImage('assets/images/raining.png');
          weatherColor = const Color.fromARGB(255, 137, 192, 255);
          break;
        }
      case ("halfCloudy"):
        {
          this.weather = "Half cloudy";
          weatherImage = const AssetImage('assets/images/halfcloudy_day.png');
          weatherColor = const Color.fromARGB(255, 255, 216, 143);
          break;
        }
      default:
        this.weather = "Weather";
    }
  }
}