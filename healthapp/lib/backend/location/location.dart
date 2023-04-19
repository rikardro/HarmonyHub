import 'package:geolocator/geolocator.dart';
import 'package:healthapp/backend/location/apiConstants.dart';
import 'package:healthapp/backend/weather/apiConstants.dart';
import 'package:http/http.dart' as http;



class Location{
/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<Position> determinePosition() async {
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
  return await Geolocator.getCurrentPosition();

  }

  Future<String> getLocationFromCoords(double latitude, double longitude) async{
    String request = "at=$latitude%2C$longitude&lang=en-US&YOUR_API_KEY";
    var url = Uri.parse(ApiConstantsGeo.revGeoCodeBaseUrl + ApiConstantsGeo.revGeoCodeEndpoint 
    + request + ApiConstantsGeo.revGeoCodeApiKey);
    var response = await http.get(url);
    print(response);
    return "hi";
  }

}

Future<void> main(List<String> args) async {
  Location locationObject = Location();
  //print("hej1");
  //Position position = await locationObject.determinePosition();
  locationObject.getLocationFromCoords(57.71, 11.97);
  //print(position);
}