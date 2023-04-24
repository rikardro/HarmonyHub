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
    String request = "&lang=en&q=$query";
    var url = Uri.parse(ApiConstantsGeo.autosuggestBaseUrl + ApiConstantsGeo.autosuggestCodeEndpoint 
    + request + ApiConstantsGeo.autosuggestType + ApiConstantsGeo.apiKey);

    print(url);

    var response = await http.get(url);
    Map<String, dynamic> valueMap = json.decode(utf8.decode(response.bodyBytes));

    print(valueMap['items']);

    return [LocationData(11.44, 57.44, "din mamma")];

  }
}

void main(List<String> args) async {
  LocationSearch locationSearch = LocationSearch();
  await locationSearch.search("Stockholm");
}