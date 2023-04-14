import 'package:flutter/material.dart';
import '../dashboard_card.dart';

class WeatherCard extends StatelessWidget {
  const WeatherCard(
      {Key? key,
      required this.weather,
      required this.degrees,
      required this.wind})
      : super(key: key);

  final String weather;
  final double degrees;
  final double wind;

  AssetImage weatherImage() {
    switch (weather) {
      case ("Sunny"):
        {
          return const AssetImage('assets/images/clear_day.png');
        }
      case ("Rainy"):
        {
          return const AssetImage('assets/images/raining.png');
        }
      case ("Cloudy"):
        {
          return const AssetImage('assets/images/cloudy.png');
        }
      case ("Foggy"):
        {
          return const AssetImage('assets/images/foggy.png');
        }
      case ("Half cloudy"):
        {
          return const AssetImage('assets/images/halfcloudy_day.png');
        }
      case ("Snowing"):
        {
          return const AssetImage('assets/images/snowing.png');
        }
      default:
        {
          return const AssetImage('assets/images/clear_day.png');
        }
    }
  }

  Color weatherColor() {
    switch (weather) {
      case ("Sunny"):
        {
          return const Color(0xFFFF9900);
        }
      case ("Rainy"):
        {
          return Color.fromARGB(255, 137, 192, 255);
        }
      case ("Cloudy"):
        {
          return const Color.fromARGB(255, 152, 166, 182);
        }
      case ("Foggy"):
        {
          return const Color.fromARGB(255, 194, 223, 255);
        }
      case ("Half cloudy"):
        {
          return Color.fromARGB(255, 255, 216, 143);
        }
      case ("Snowing"):
        {
          return const Color.fromARGB(255, 203, 210, 255);
        }
      default:
        {
          return const Color.fromARGB(255, 114, 180, 255);
        }
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
        color: weatherColor(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: weatherImage(),
                  width: 100,
                ),
              ],
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
                      Text("$degrees °C",
                          style: TextStyle(
                              fontSize: 20,
                              color: baseTextStyle.color,
                              fontFamily: baseTextStyle.fontFamily,
                              shadows: baseTextStyle.shadows)),
                      Text("$wind m/s",
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
