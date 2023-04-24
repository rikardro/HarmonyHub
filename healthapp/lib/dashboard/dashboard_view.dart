import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator_platform_interface/src/models/position.dart';
import 'package:healthapp/backend/location/location.dart';
import 'package:healthapp/backend/weather/recommended_days_repo.dart';
import 'package:healthapp/backend/weather/weather.dart';
import 'package:healthapp/bloc/running_bloc.dart';
import 'package:healthapp/caffeine_repository.dart';
import 'package:healthapp/dashboard/dashboard_cards/air_quality_card.dart';
import 'package:healthapp/dashboard/dashboard_cards/caffeine_card.dart';
import 'package:healthapp/dashboard/dashboard_cards/health_card.dart';
import 'package:healthapp/dashboard/dashboard_cards/suggested_running_card.dart';
import 'package:healthapp/dashboard/dashboard_cards/weather_card.dart';
import 'package:healthapp/util/weatherInformation.dart';

import '../bloc/caffeine_bloc.dart';

class DashboardView extends StatelessWidget {
  DashboardView({Key? key}) : super(key: key);

  final topTextStyle = TextStyle(
      fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey[600]);

  Future<Location> fetchLocation() async {
    return await Location.create();
  }

  Future<WeatherInformationCurrent> fetchWeatherData(Position position) async {
    ApiParser apiParser = ApiParser();
    WeatherInformationCurrent wi = await apiParser.requestCurrentWeather(position.latitude, position.longitude);
    return wi;
  }

  


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchLocation(),
      builder: (context, AsyncSnapshot<Location> location) {
      if(location.hasData){
        return Container(
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Välkommen!",
                      style: topTextStyle,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.grey[600],
                        ),
                        Text(location.data!.locationName, style: topTextStyle)
                      ],
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  FutureBuilder(
                      future: fetchWeatherData(location.data!.position),
                      builder:
                          (context, AsyncSnapshot<WeatherInformationCurrent> weatherData) {
                          return WeatherCard(weatherData);
                      }),
                  AirQualityCard(quality: "Good")
                ],
              ),
              Row(
                children: [
                  HealthCard(
                    title: "Steps",
                    value: "3457",
                    icon: Icons.directions_walk,
                    iconColor: Colors.grey[600],
                  ),
                  const HealthCard(
                      title: "Heart",
                      value: "69",
                      icon: Icons.favorite,
                      iconColor: Colors.red)
                ],
              ),
              Row(
                children: [
                  HealthCard(
                    flex: 5,
                    height: 120,
                    title: "Flights",
                    value: "13",
                    icon: Icons.stairs,
                    iconColor: Colors.grey[600],
                    topPadding: 24,
                  ),
                  BlocProvider(
                    create: (context) => CaffeineBloc(CaffeineRepository())
                      ..add(const FetchCaffeine()),
                    child: CaffeineCard(),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(12, 16, 12, 0),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Suggested running days",
                  style: topTextStyle,
                ),
              ),
              BlocProvider(
                  create: (context) => RunningBloc(RecommendedDaysRepo(apiClient: ApiParser()))
                    ..add(const FetchRecommended()),
                  child: BlocBuilder<RunningBloc, RunningState>(
                    builder: (context, state){
                      if(state.status == RunningStatus.loading){
                        return CircularProgressIndicator();
                      } else{
                        final recommended = state.intervals ?? [];
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: recommended.length,
                          itemBuilder: (BuildContext context, int index){
                            return SuggestedRunningCard(interval: recommended[index]);
                          });
                      }
                    },
                  )
              )
              
            ],
          ),
        );
      }else{
        return Container(color: Colors.white, child: const Center(child: CircularProgressIndicator()));
      }
    });
  }
}
