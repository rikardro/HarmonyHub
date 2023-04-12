// Gets the information from the api in json format and parses it to a dart object
import 'dart:ffi';

import 'package:healthapp/backend/weather/apiConstants.dart';

class apiParser{
  var ulr = Uri.parse(ApiConstants.baseUrl + ApiConstants.usersEndpoint);
  
  Null requestWeather(Float latitude, Float longitude){
    String request = "?latitude=$latitude&longitude=$longitude";
  
  }
}
