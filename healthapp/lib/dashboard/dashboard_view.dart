import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthapp/backend/location/location.dart';
import 'package:healthapp/backend/location/location_search.dart';
import 'package:healthapp/backend/weather/weather.dart';
import 'package:healthapp/bloc/running_bloc.dart';
import 'package:healthapp/dashboard/dashboard_cards/air_quality_card.dart';
import 'package:healthapp/dashboard/dashboard_cards/caffeine_card.dart';
import 'package:healthapp/dashboard/dashboard_cards/run_tracker_card.dart';
import 'package:healthapp/dashboard/dashboard_cards/quote_card.dart';
import 'package:healthapp/dashboard/dashboard_cards/weather_card.dart';
import 'package:healthapp/dashboard/running_preferences.dart';
import 'package:healthapp/profile_view.dart';
import 'package:healthapp/util/weatherInformation.dart';
import 'package:healthapp/util/weatherPreferences.dart';
import '../backend/greetingPhrase.dart';
import '../bloc/air_quality_bloc.dart';
import '../bloc/location_bloc.dart';
import '../bloc/location_search_bloc.dart';
import '../bloc/quote_bloc.dart';
import '../bloc/user_bloc.dart';
import 'dashboard_cards/SuggestedRunningCards.dart';
import 'dashboard_cards/breathing_card.dart';

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
    return ListView(
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
                        String initials = state.initals ?? "";
                        initials = initials.toUpperCase();
                        return CircleAvatar(
                          backgroundColor: Colors.blueGrey,
                          radius: 25,
                          child: Text(
                            initials,
                            style: const TextStyle(
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
                    '${GreetingPhrase.get()} 👋',
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
                  if (weatherData.hasData) {
                    return WeatherCard(weatherData: weatherData);
                  }
                  return const CircularProgressIndicator();
                }),
            BlocProvider(
                create: (context) => AirQualityBloc()..add(const FetchAirQuality()),
                child: AirQualityCard())
          ],
        ),
        Row(
          children: [
            BlocProvider(
              create: (context) => QuoteBloc()..add(FetchQuote()),
              child: const QuoteCard(),
            ),
            const RunTrackerCard(),
          ],
        ),
        Row(
          children: const [
            AudioPlayerCard(),
            CaffeineCard(),
          ],
        ),
        Column(children: [
          Container(
            margin: const EdgeInsets.fromLTRB(12, 16, 12, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Suggested running days",
                  style: topTextStyle,
                ),
                ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            context
                                .read<RunningBloc>()
                                .add(const FetchPreferences());
                            return BlocBuilder<RunningBloc, RunningState>(
                              builder: (context, state) {
                                if (state.status == RunningStatus.loading) {
                                  return Container();
                                } else {
                                  WeatherPreferences preference =
                                      state.preferences ??
                                          WeatherPreferences(
                                              18,
                                              true,
                                              0,
                                              25,
                                              0,
                                              const TimeOfDay(
                                                  hour: 4, minute: 59),
                                              const TimeOfDay(
                                                  hour: 22, minute: 01));
                                  final temperature = preference.targetTemp;
                                  final precipitation = preference.rainPref;
                                  final cloudCoverage = preference.cloudPref;
                                  final windSpeed = preference.windPref;
                                  final snow = preference.avoidSnow;
                                  final startTime = preference.startTime;
                                  final endTime = preference.endTime;
                                  return RunningPreferences(
                                      temperature,
                                      precipitation,
                                      cloudCoverage,
                                      windSpeed,
                                      snow,
                                      startTime,
                                      endTime);
                                }
                              },
                            );
                          });
                    },
                    child: const Text("Preferences"))
              ],
            ),
          ),
          SuggestedRunningCards(),
        ]),
      ],
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
