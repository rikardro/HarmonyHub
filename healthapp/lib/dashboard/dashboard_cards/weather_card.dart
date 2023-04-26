import 'package:flutter/material.dart';
import 'package:healthapp/util/cardinalDirections.dart';
import 'package:healthapp/util/weatherType.dart';
import 'package:healthapp/util/weatherVisuals.dart';
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
      //isDay = weatherData.data!.sun_up;
      windDirection = weatherData.data!.windDirectionCardinal.value;
      WeatherVisuals.getWeatherVisuals(w);
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
        ));
  }
}
