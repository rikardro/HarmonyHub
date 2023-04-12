// Gets the information from the api in json format and parses it to a dart object
import 'dart:ffi';

import 'package:healthapp/backend/weather/apiConstants.dart';

class apiParser{
  var ulr = Uri.parse(ApiConstants.baseUrl + ApiConstants.usersEndpoint);
  
  Null requestWeather(Float latitude, Float longitude){
    String request = "?latitude=$latitude&longitude=$longitude&hourly=temperature_2m,weathercode,cloudcover,precipitation,snowfall,windspeed_10m,winddirection_10m&start_date=2023-04-12&end_date=2023-04-12";
    
  }



}
