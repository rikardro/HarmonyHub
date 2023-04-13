// Gets the information from the api in json format and parses it to a dart object
import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:healthapp/backend/weather/apiConstants.dart';

class ApiParser{
  
  void requestWeather(double latitude, double longitude) async{
    String request = "?latitude=$latitude&longitude=$longitude&hourly=temperature_2m,precipitation,snowfall,snow_depth,weathercode,cloudcover,windspeed_10m,winddirection_10m";
    var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.usersEndpoint + request);
    var response = await http.get(url);
    if(response.statusCode == 200){
      print(response.body);
    }
  }

}

  void main(){
    ApiParser api = new ApiParser();
    api.requestWeather(58.0, 12.0);
  }

