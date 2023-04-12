import 'package:flutter/material.dart';
import '../dashboard_card.dart';

class CaffeineCard extends StatelessWidget {
  final int caffeine;

  const CaffeineCard({Key? key, required this.caffeine}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      flex: 12,
      color: Color(0xFFEB7D7A),
      child: Padding(
        padding: const EdgeInsets.only(right: 15.0, left: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              //color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Caffeine level',
                    style: TextStyle(fontSize: 21, color: Colors.white),
                  ),
                  Text(
                    '~ $caffeine mg',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
            Container(
              //color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.coffee,
                    size: 35,
                    color: Color(0xFFFAD6CA),
                  ),
                  Text(
                    'Low',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF05FF00),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
