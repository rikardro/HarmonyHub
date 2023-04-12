import 'package:flutter/material.dart';
import 'dashboard_card.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              DashboardCard(flex: 5, color: Colors.green,),
              DashboardCard(flex: 10, color: Colors.red,),
            ],
          ),
          Row(
            children: [
              DashboardCard(flex: 10, color: Colors.blue,),
              DashboardCard(flex: 5, color: Colors.grey,),
            ],
          )
        ],
      ),
    );
  }
}
