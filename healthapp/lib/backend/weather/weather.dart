// Gets the information from the api in json format and parses it to a dart object
import 'dart:convert';
import 'package:healthapp/backend/weather/customExceptions.dart';
import 'package:healthapp/backend/weather/parseJson.dart';
import 'package:healthapp/util/weatherInformation.dart';
import 'package:http/http.dart' as http;
import 'package:healthapp/backend/weather/apiConstants.dart';

class ApiParser{
  
  Future<List<WeatherInformation>> requestWeather(double latitude, double longitude) async{
    String request = "?latitude=$latitude&longitude=$longitude&hourly=temperature_2m,precipitation,snowfall,snow_depth,weathercode,cloudcover,windspeed_10m,winddirection_10m";
    var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.usersEndpoint + request);
    var response = await http.get(url);
    if(response.statusCode == 200){
      JsonParser jsonParser = JsonParser(response.body.toString());
      List<WeatherInformation> wi = jsonParser.jsonDataConverter();
      return wi;
    } else {
      throw APIException('could not load data from Meteo weather API');
    }
  }

}

  void main(){
    ApiParser api = new ApiParser();
    api.requestWeather(58.0, 12.0);
  }

