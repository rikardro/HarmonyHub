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
import 'package:healthapp/util/weatherInformation.dart';

import '../bloc/air_quality_bloc.dart';
import '../bloc/caffeine_bloc.dart';
import '../bloc/location_bloc.dart';
import '../bloc/location_search_bloc.dart';

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
                    BlocBuilder<LocationBloc, LocationState>(
                      builder: (context, state) {
                        if (state.status == LocationStatus.loading) {
                          return Text("");
                        } else {
                          return Text(state.locationName ?? "",
                              style: topTextStyle);
                        }
                      },
                    )
                  ],
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
                create: (context) => AirQualityBloc()..add(FetchAirQuality()),
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
              CaffeineCard()
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
          Column(
            children: [SuggestedRunningCard(), SuggestedRunningCard()],
          ),
          TextButton(
            onPressed: () {
              // change location
              /* BlocProvider.of<LocationBloc>(context).add(
                LocationChanged(
                  latitude: 57.70,
                  longitude: 11.97,
                  useCurrentLocation: false,
                ),
              ); */

              showModalBottomSheet(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                context: context,
                builder: (context) {
                  return BlocProvider(
                    create: (context) => LocationSearchBloc(),
                    child: LocationPopup(),
                  );
                },
              );
            },
            child: Text("Byt plats"),
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
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search for a location',
                ),
                onChanged: (value) async {
                  await Future.delayed(Duration(milliseconds: 500));
                  setState(() {
                    context.read<LocationSearchBloc>().add(
                          LocationsSearchFetch(
                            searchQuery: value,
                          ),
                        );
                  });
                },
              ),
              SizedBox(height: 16.0),
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
                        child: ListTile(
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
              /* SizedBox(height: 16.0),
              Container(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    // TODO: Implement save logic
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      "Save",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ) */
            ],
          ),
        );
      },
    );
  }
}
