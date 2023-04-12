import 'package:flutter/material.dart';
import '../dashboard_card.dart';

class HealthCard extends StatelessWidget {
  const HealthCard({Key? key,
    this.height = 100,
    this.flex = 1,
    required this.title,
    required this.icon,
    required this.value,
    this.iconColor,
    this.topPadding = 16}) : super(key: key);
  final double? height;
  final int? flex;
  final String title;
  final IconData icon;
  final Color? iconColor;
  final String value;
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      height: height,
      flex: flex,
      color: Colors.white,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(title, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: Colors.grey[600]),)
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(8, topPadding, 8, 0),
              child: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                    child: Icon(icon, color: iconColor, size: 30,),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                    child: Text(value,
                      style: TextStyle(
                          fontSize: 30, fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                      ),),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
