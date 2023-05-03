import 'dart:async';
import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:healthapp/backend/location/apiConstants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show utf8;

class Location {
  late double longitude;
  late double latitude;
  late String locationName;
  
  // Static instance variable
  static Location? _instance;

  // Private constructor
  Location._create();

  // Static method to access the singleton instance
  static Future<Location> getInstance() async {
    if (_instance == null) {
      _instance = Location._create();
      await _instance!._init();
    }
    return _instance!;
  }

  setCustomPosition(double latitude, double longitude) async{
    this.latitude = latitude;
    this.longitude = longitude;
    await setLocationNameFromCoords(latitude, longitude);
  }

  setCurrentPosition() async{
    await _init();
  }

  Future _init() async{
    await determinePosition();
    await setLocationNameFromCoords(latitude, longitude);
  }

  // Determine the current position of the device.
  Future determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the 
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale 
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately. 
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.

    Position position = await Geolocator.getCurrentPosition();

    latitude = position.latitude;
    longitude = position.longitude;
    print("Latitude: $latitude, Longitude: $longitude");
  }

  Stream<Position> getPosStream(){
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 25,
    );
    return Geolocator.getPositionStream(locationSettings: locationSettings);
  }


  // Set the location name from the current position.
  Future setLocationNameFromCoords(double latitude, double longitude) async{
    String request = "at=$latitude%2C$longitude&lang=en-US";
    var url = Uri.parse(ApiConstantsGeo.revGeoCodeBaseUrl + ApiConstantsGeo.revGeoCodeEndpoint 
    + request + ApiConstantsGeo.apiKey);
    var response = await http.get(url);
    Map<String, dynamic> valueMap = json.decode(utf8.decode(response.bodyBytes));
    locationName = valueMap['items'][0]['address']['city'];
  }
}
