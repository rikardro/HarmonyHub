import 'package:flutter/material.dart';
import 'package:healthapp/util/cardinalDirections.dart';
import 'package:healthapp/util/weatherType.dart';
import '../../util/weatherInformation.dart';
import '../dashboard_card.dart';

class WeatherCard extends StatelessWidget {
  bool isDay = true;
  AssetImage weatherImage = const AssetImage('assets/images/clear_day.png');
  Color weatherColor = const Color(0xFFFF9900);

  String weather = "";

  double temperature = 0;
  double windSpeed = 0; 
  String windDirection = "";

  WeatherCard(AsyncSnapshot<WeatherInformationCurrent> weatherData, {Key? key})
      : super(key: key) {
    if (weatherData.hasData) {
      String w = weatherData.data!.weatherType.toShortString();
      temperature = weatherData.data!.temperature;
      windSpeed = weatherData.data!.windspeed;
      isDay = weatherData.data!.sun_up;
      windDirection = weatherData.data!.windDirectionCardinal.value;
      init(w, isDay);
    }
  }

  init(String weather, bool isDay) {
    switch (weather) {
      case ("clear"):
        {
          if (isDay) {
            this.weather = "Sunny";
            weatherImage = const AssetImage('assets/images/clear_day.png');
            weatherColor = const Color(0xFFFF9900);
          } else {
            this.weather = "Clear";
            weatherImage = const AssetImage('assets/images/clear_night.png');
            weatherColor = const Color.fromARGB(255, 115, 22, 255);
          }
          break;
        }
      case ("cloudy"):
        {
          this.weather = "Cloudy";
          weatherImage = const AssetImage('assets/images/cloudy.png');
          if (isDay) {
            weatherColor = const Color.fromARGB(255, 152, 166, 182);
          } else {
            weatherColor = const Color.fromARGB(255, 115, 22, 255);
          }
          break;
        }
      case ("foggy"):
        {
          this.weather = "Foggy";
          weatherImage = const AssetImage('assets/images/foggy.png');
          if (isDay) {
            weatherColor = const Color.fromARGB(255, 194, 223, 255);
          } else {
            weatherColor = const Color.fromARGB(255, 115, 22, 255);
          }
          break;
        }
      case ("snowing"):
        {
          this.weather = "Snowing";
          weatherImage = const AssetImage('assets/images/snowing.png');
          if (isDay) {
            weatherColor = const Color.fromARGB(255, 203, 210, 255);
          } else {
            weatherColor = const Color.fromARGB(255, 115, 22, 255);
          }
          break;
        }
      case ("raining"):
        {
          this.weather = "Raining";
          weatherImage = const AssetImage('assets/images/raining.png');
          if (isDay) {
            weatherColor = const Color.fromARGB(255, 137, 192, 255);
          } else {
            weatherColor = const Color.fromARGB(255, 115, 22, 255);
          }
          break;
        }
      case ("halfCloudy"):
        {
          if (isDay) {
            this.weather = "Half cloudy";
            weatherImage = const AssetImage('assets/images/halfcloudy_day.png');
            weatherColor = const Color.fromARGB(255, 255, 216, 143);
          } else {
            this.weather = "Half cloudy";
            weatherImage =
                const AssetImage('assets/images/halfcloudy_night.png');
            weatherColor = const Color.fromARGB(255, 115, 22, 255);
          }
          break;
        }
      default:
        this.weather = "Weather";
    }
  }

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

    return DashboardCard(
        flex: 12,
        color: weatherColor,
        child: GestureDetector(onTap: () => print("hej"),
          behavior: HitTestBehavior.opaque,
          child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image(image: weatherImage, width: 80)],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(weather,
                          style: TextStyle(
                              fontSize: 25,
                              color: baseTextStyle.color,
                              fontFamily: baseTextStyle.fontFamily,
                              shadows: baseTextStyle.shadows,
                              fontWeight: FontWeight.w500)),
                      Text("$temperature °C",
                          style: TextStyle(
                              fontSize: 20,
                              color: baseTextStyle.color,
                              fontFamily: baseTextStyle.fontFamily,
                              shadows: baseTextStyle.shadows)),
                      Text("$windSpeed m/s $windDirection",
                          style: TextStyle(
                              fontSize: 16,
                              color: baseTextStyle.color,
                              fontFamily: baseTextStyle.fontFamily,
                              shadows: baseTextStyle.shadows))
                    ],
                  ),
                ),
              ],
            ),
          ],
        )));
  }
}
