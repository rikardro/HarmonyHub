import 'package:flutter/material.dart';

import 'package:healthapp/dashboard/dashboard_card.dart';
import 'package:healthapp/util/weatherInformation.dart';
import 'package:healthapp/util/weatherType.dart';

class WeeklyWeatherCard extends StatelessWidget {
  late WeatherInformationWeekly wi;
  late String day;
  late AssetImage weatherImage;
  late Color weatherColor;
  late String weather;

  WeeklyWeatherCard(this.wi, this.day, {Key? key}) : super(key: key) {
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
    final baseTextStyle = TextStyle(
      color: Colors.white,
      fontSize: 15,
      fontFamily: 'Inter',
      shadows: [
        Shadow(
          blurRadius: 10,
          offset: const Offset(2, 2),
          color: Colors.black.withOpacity(0.3),
        ),
      ],
    );

    final dayTextStyle = TextStyle(
      color: Colors.white,
      fontSize: 17  ,
      fontWeight: FontWeight.bold,
      fontFamily: 'Inter',
      shadows: [
        Shadow(
          blurRadius: 10,
          offset: const Offset(2, 2),
          color: Colors.black.withOpacity(0.3),
        ),
      ],
    );

    return DashboardCard(
      flex: 0,
      color: Color.fromARGB(189, 83, 189, 246),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 90,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(day, style: dayTextStyle),
                  Image(image: weatherImage, width: 60,),
                ],
              ),
            ),
            SizedBox(
              width: 90,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Image(
                    image: AssetImage('assets/images/degrees.png'),
                    width: 50,
                    height: 50,
                  ),
                  Text("${wi.maxTemperature} / ${wi.minTemperature} °",
                      style: baseTextStyle),
                ],
              ),
            ),
            SizedBox(
              width: 75,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Image(
                    image: AssetImage('assets/images/precipitation.png'),
                    width: 50,
                    height: 50,
                  ),
                  Text("${wi.precipitation} mm", style: baseTextStyle)
                ],
              ),
            ),
            SizedBox(
              width: 75,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Image(
                    image: AssetImage('assets/images/wind_white.png'),
                    width: 50,
                    height: 50,
                  ),
                  Text("${wi.maxWindspeed} m/s", style: baseTextStyle)
                ],
              ),
            ),
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
