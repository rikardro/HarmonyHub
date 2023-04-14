import 'package:flutter/material.dart';
import '../dashboard_card.dart';

class WeatherCard extends StatelessWidget {
  const WeatherCard({Key? key, required this.weather, required this.degrees, required this.wind}) : super(key: key);
  
  final String weather;
  final double degrees;
  final double wind;



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
      flex: 12, color: const Color(0xFFFF9900),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Image(image: AssetImage('assets/images/sun.png'),
              width: 100,),
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
                    Text(weather, style: TextStyle(fontSize: 25, color: baseTextStyle.color, fontFamily: baseTextStyle.fontFamily, shadows: baseTextStyle.shadows, fontWeight: FontWeight.w500)),
                    Text("$degrees °C", style: TextStyle(fontSize: 20, color: baseTextStyle.color, fontFamily: baseTextStyle.fontFamily, shadows: baseTextStyle.shadows)),
                    Text("$wind m/s", style: TextStyle(fontSize: 16, color: baseTextStyle.color, fontFamily: baseTextStyle.fontFamily, shadows: baseTextStyle.shadows))
                  ],
                ),
              ),
            ],
          ),
        ],
      ));
  }
}
