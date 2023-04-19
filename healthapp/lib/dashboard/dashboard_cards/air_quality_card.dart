import 'package:flutter/material.dart';
import '../dashboard_card.dart';

class AirQualityCard extends StatelessWidget {
  AirQualityCard({Key? key, required this.quality}) : super(key: key);

  final String quality;

  final textShadow = Shadow(
    blurRadius: 10,
    offset: const Offset(2, 2),
    color: Colors.black.withOpacity(0.3),
  );

  List<Color> qualityColor() {
    switch (quality) {
      case ("Good"):
        {
          return const [Color(0xFF05FF00), Color(0xFF00FFFF)];
        }
      case ("Poor"):
        {
          return const [
            Color.fromARGB(255, 252, 94, 94),
            Color.fromARGB(255, 255, 141, 89)
          ];
        }
      case ("Okey"):
        {
          return const [
            Color.fromARGB(255, 255, 184, 78),
            Color.fromARGB(255, 255, 237, 73)
          ];
        }
      default:
        return const [Color(0xFF05FF00), Color(0xFF00FFFF)];
    }
  }

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      flex: 5, color: const Color(0xFF7EC9FF),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Air quality",
                style: TextStyle(
                    shadows: [textShadow], color: Colors.white, fontSize: 15)),
            const Image(
              image: AssetImage('assets/images/wind_white.png'),
              width: 60,
            ),
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: qualityColor(),
              ).createShader(bounds),
              child: Text(
                quality,
                style: TextStyle(
                  shadows: [textShadow],
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ), // CONTENT HERE
    );
  }
}