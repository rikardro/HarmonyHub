import 'dart:convert';

import 'package:healthapp/backend/location/apiConstants.dart';
import 'package:healthapp/backend/location/location.dart';
import 'package:http/http.dart' as http;


class LocationData{
  final double latitude;
  final double longitude;
  final String name;

  LocationData(this.latitude, this.longitude, this.name);

}


class LocationSearch{
  Future<List<LocationData>> search(String query) async{

    List<LocationData> locations = [];

    String request = "&lang=en&q=$query";
    var url = Uri.parse(ApiConstantsGeo.autosuggestBaseUrl + ApiConstantsGeo.autosuggestCodeEndpoint 
    + request + ApiConstantsGeo.autosuggestType + ApiConstantsGeo.apiKey);

    var response = await http.get(url);
    Map<String, dynamic> valueMap = json.decode(utf8.decode(response.bodyBytes));

    List<dynamic> items = valueMap['items'];

    for (final item in items){
      String city = item['address']['label'].split(",")[0].trim();
      locations.add(LocationData(item['position']['lat'], item['position']['lng'], city));
    }
    return locations;

  }
}

void main(List<String> args) async {
  LocationSearch locationSearch = LocationSearch();

  List<LocationData> locations = await locationSearch.search("St");

  for(final location in locations){
    print(location.name);
    print([location.latitude, location.longitude]);
  }
}