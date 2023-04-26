import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator_platform_interface/src/models/position.dart';
import 'package:healthapp/backend/location/location.dart';
import 'package:healthapp/backend/location/location_search.dart';
import 'package:healthapp/backend/weather/weather.dart';
import 'package:healthapp/caffeine_repository.dart';
import 'package:healthapp/dashboard/dashboard_cards/air_quality_card.dart';
import 'package:healthapp/dashboard/dashboard_cards/caffeine_card.dart';
import 'package:healthapp/dashboard/dashboard_cards/health_card.dart';
import 'package:healthapp/dashboard/dashboard_cards/suggested_running_card.dart';
import 'package:healthapp/dashboard/dashboard_cards/weather_card.dart';
import 'package:healthapp/profile_view.dart';
import 'package:healthapp/util/weatherInformation.dart';

import '../bloc/air_quality_bloc.dart';
import '../bloc/caffeine_bloc.dart';
import '../bloc/location_bloc.dart';
import '../bloc/location_search_bloc.dart';
import '../bloc/user_bloc.dart';

class DashboardView extends StatelessWidget {
  DashboardView({Key? key}) : super(key: key);

  final topTextStyle = TextStyle(
      fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey[600]);

  Future<Location> fetchLocation() async {
    return await Location.getInstance();
  }

  Future<WeatherInformationCurrent> fetchWeatherData() async {
    ApiParser apiParser = ApiParser();
    WeatherInformationCurrent wi = await apiParser.requestCurrentWeather();
    return wi;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileView()));
                      },
                      child: BlocBuilder<UserBloc, UserState>(
                        builder: (context, state) {
                          return CircleAvatar(
                            backgroundColor: Colors.blueGrey,
                            radius: 25,
                            child: Text(
                              state.initals!.toUpperCase(),
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Välkommen!",
                      style: topTextStyle,
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      context: context,
                      builder: (context) {
                        return BlocProvider(
                          create: (context) => LocationSearchBloc(),
                          child: const LocationPopup(),
                        );
                      },
                    );
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.grey[600],
                      ),
                      BlocBuilder<LocationBloc, LocationState>(
                        builder: (context, state) {
                          if (state.status == LocationStatus.loading) {
                            return const Text("");
                          } else {
                            return Text(state.locationName ?? "",
                                style: topTextStyle);
                          }
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Row(
            children: [
              FutureBuilder(
                  future: fetchWeatherData(),
                  builder: (context,
                      AsyncSnapshot<WeatherInformationCurrent> weatherData) {
                    return WeatherCard(weatherData);
                  }),
              BlocProvider(
                create: (context) =>
                    AirQualityBloc()..add(const FetchAirQuality()),
                child: AirQualityCard(),
              ),
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
              const CaffeineCard()
            ],
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(12, 16, 12, 0),
            alignment: Alignment.centerLeft,
            child: Text(
              "Suggested running days",
              style: topTextStyle,
            ),
          ),
          Column(
            children: [SuggestedRunningCard(), SuggestedRunningCard()],
          ),
        ],
      ),
    );
  }
}

const Color lightBlack = Color(0xFF3A3A3A);

class LocationPopup extends StatefulWidget {
  const LocationPopup({Key? key}) : super(key: key);

  @override
  _LocationPopupState createState() => _LocationPopupState();
}

class _LocationPopupState extends State<LocationPopup> {
  TextEditingController _searchController = TextEditingController();
  List<LocationData> _searchResults = [];

  Future<void> addLocation(
      bool useCurrentLocation, double? latitude, double? longitude) async {
    if (useCurrentLocation) {
      context.read<LocationBloc>().add(
            const LocationChanged(
              latitude: null,
              longitude: null,
              useCurrentLocation: true,
            ),
          );
    } else {
      context.read<LocationBloc>().add(
            LocationChanged(
              latitude: latitude,
              longitude: longitude,
              useCurrentLocation: false,
            ),
          );
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationSearchBloc, LocationSearchState>(
      builder: (context, state) {
        if (state.status == LocationSearchStatus.success) {
          _searchResults = state.locations!;
        }
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search for a location',
                ),
                onChanged: (value) async {
                  await Future.delayed(const Duration(milliseconds: 500));
                  setState(() {
                    context.read<LocationSearchBloc>().add(
                          LocationsSearchFetch(
                            searchQuery: value,
                          ),
                        );
                  });
                },
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: ListView.builder(
                  itemCount: _searchController.text.isEmpty
                      ? 1
                      : _searchResults.length,
                  itemBuilder: (context, index) {
                    if (_searchController.text.isEmpty) {
                      return GestureDetector(
                        onTap: () {
                          addLocation(true, null, null);
                        },
                        child: const ListTile(
                          leading: Icon(Icons.my_location),
                          title: Text('Current location'),
                        ),
                      );
                    } else {
                      final result = _searchResults[index];
                      return GestureDetector(
                        onTap: () {
                          addLocation(false, result.latitude, result.longitude);
                        },
                        child: Card(
                          child: ListTile(
                            title: Text(result.name),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
