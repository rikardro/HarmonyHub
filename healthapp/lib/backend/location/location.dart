import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:healthapp/backend/location/apiConstants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show utf8;



class Location{
  late Position position;
  late String locationName;



  Location._create();

  static Future<Location> create() async{
    Location location = Location._create();
    await location._init();
    return location;
  }

  Future _init() async{
    await determinePosition();
    print("location fungerar");
    await setLocationNameFromCoords();
    print("location name fungerar");
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
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
    position = await Geolocator.getCurrentPosition();
    }

    Future setLocationNameFromCoords() async{
      String request = "at=${position.latitude}%2C${position.longitude}&lang=en-US";
      var url = Uri.parse(ApiConstantsGeo.revGeoCodeBaseUrl + ApiConstantsGeo.revGeoCodeEndpoint 
      + request + ApiConstantsGeo.revGeoCodeApiKey);
      print(url);
      var response = await http.get(url);
      print(response.body);
      Map<String, dynamic> valueMap = json.decode(utf8.decode(response.bodyBytes));
      print(valueMap['items']);
      locationName = valueMap['items'][0]['address']['city'];
      print(locationName);
    }

}

Future<void> main(List<String> args) async {
  Location locationObject = await Location.create();
  print(locationObject.locationName);

}