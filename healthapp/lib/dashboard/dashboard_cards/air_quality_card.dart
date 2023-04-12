import 'package:flutter/material.dart';
import '../dashboard_card.dart';

class AirQualityCard extends StatelessWidget {
  AirQualityCard({Key? key}) : super(key: key);

  final textShadow = Shadow(
    blurRadius: 10,
    offset: const Offset(2, 2),
    color: Colors.black.withOpacity(0.3),
  );

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      flex: 5, color: const Color(0xFF7EC9FF),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Air quality", style: TextStyle(shadows: [textShadow], color: Colors.white)),
          const Image(image: AssetImage('assets/images/Air.png')),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFF05FF00), Color(0xFF00FFFF)],
            ).createShader(bounds),
            child: Text('Good',
              style: TextStyle(
                shadows: [textShadow], 
                fontWeight: FontWeight.bold,
                fontSize: 25.0,
                color: Colors.white,
              ),
            ),
          )
        ],
      ), // CONTENT HERE
    );
  }
}
