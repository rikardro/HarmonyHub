import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthapp/bloc/caffeine_bloc.dart';
import 'package:healthapp/bloc/caffeine_bloc.dart';
import '../dashboard_card.dart';

class CaffeineCard extends StatelessWidget {
  const CaffeineCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      flex: 12,
      color: Color(0xFFEB7D7A),
      child:
          BlocBuilder<CaffeineBloc, CaffeineState>(builder: (context, state) {
        //log(state.status.toString() + "hej");
        if (state.status == CaffeineStatus.loading) {
          return CircularProgressIndicator();
        } else {
          final caffeine = state.caffeine!.toInt();
          final status = state.caffeineStatus;
          return Padding(
            padding: const EdgeInsets.only(right: 15.0, left: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.coffee,
                      size: 35,
                      color: Color(0xFFFAD6CA),
                    ),
                    Text(
                      '$status',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF05FF00),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        }
      }),
    );
  }
}
