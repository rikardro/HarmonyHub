import 'package:flutter/material.dart';
import '../dashboard_card.dart';

class WeatherCard extends StatelessWidget {
  const WeatherCard({Key? key}) : super(key: key);
  
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
        children: [
          Column(
            children: const [
              Image(image: AssetImage('assets/images/3d-sun-with-smile-face-cartoon-style-rendered-object-illustration-png 1.png'),
              width: 100,),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Sunny", style: TextStyle(fontSize: 25, color: baseTextStyle.color, fontFamily: baseTextStyle.fontFamily, shadows: baseTextStyle.shadows, fontWeight: FontWeight.w500)),
                    Text("17 °C", style: TextStyle(fontSize: 20, color: baseTextStyle.color, fontFamily: baseTextStyle.fontFamily, shadows: baseTextStyle.shadows)),
                    Text("3 m/s", style: TextStyle(fontSize: 16, color: baseTextStyle.color, fontFamily: baseTextStyle.fontFamily, shadows: baseTextStyle.shadows))
                  ],
              ),
            ),
            ],
          ),
        ],
      ));
  }
}
