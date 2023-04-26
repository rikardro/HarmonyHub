// Gets the information from the api in json format and parses it to a dart object
import 'dart:convert';
import 'package:healthapp/backend/location/location.dart';
import 'package:healthapp/backend/weather/customExceptions.dart';
import 'package:healthapp/backend/weather/parseJson.dart';
import 'package:healthapp/backend/weather/sunUp.dart';
import 'package:healthapp/util/weatherInformation.dart';
import 'package:healthapp/util/weatherType.dart';
import 'package:http/http.dart' as http;
import 'package:healthapp/backend/weather/apiConstants.dart';

class ApiParser {
  // returns a list of the hourly weather information for the next seven days
  Future<List<WeatherInformation>> requestWeather(
      double latitude, double longitude) async {
    String request =
        "?latitude=$latitude&longitude=$longitude&hourly=temperature_2m,precipitation,snowfall,snow_depth,weathercode,cloudcover,windspeed_10m,winddirection_10m&windspeed_unit=ms&timezone=Europe%2FBerlin";
    var url =
        Uri.parse(ApiConstants.baseUrl + ApiConstants.usersEndpoint + request);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      JsonParser jsonParser = JsonParser(response.body.toString());
      List<WeatherInformation> wi = jsonParser.jsonDataConverter();
      return wi;
    } else {
      throw APIException('could not load data from Meteo weather API');
    }
  }

  // returns weather for the current hour, switching to next on :45 minutes+
  Future<WeatherInformationCurrent> requestCurrentWeather() async {
    Location location = await Location.getInstance();
    double latitude = location.latitude;
    double longitude = location.longitude;

    String request =
        "?latitude=$latitude&longitude=$longitude&hourly=temperature_2m,precipitation,snowfall,snow_depth,weathercode,cloudcover,windspeed_10m,winddirection_10m&windspeed_unit=ms&timezone=Europe%2FBerlin";
    var url =
        Uri.parse(ApiConstants.baseUrl + ApiConstants.usersEndpoint + request);
    var response = await http.get(url);
    var time = DateTime.now();
    int hour = time.hour;
    double currentTime = (time.hour + time.minute / 60);

    if (time.minute >= 45) {
      hour += 1;
    }

    if (response.statusCode == 200) {
      JsonParser jsonParser = JsonParser(response.body.toString());
      List<WeatherInformation> wiList = jsonParser.jsonDataConverter();
      WeatherInformation wi = wiList[hour];
      WeatherInformationCurrent now = WeatherInformationCurrent(wi.time, wi.temperature, wi.precipitation, wi.snowfall, 
      wi.snow_depth, wi.weather, wi.cloudcover, wi.windspeed, wi.windDegrees);
      SunUp sunUp = await getSunUp(latitude, longitude);
      now.setsun_up(sunUp.currentSunIsUp());
      return now;
    } else {
      throw APIException('could not load data from Meteo weather API');
    }
  }
  
  Future<SunUp> getSunUp(double latitude, double longitude) async{
    String request = "lat=$latitude&lng=$longitude&timezone=EET&date=today";
    var url = Uri.parse(ApiConstants.sunsetSunrise + request);
    var response = await http.get(url);
    SunUp sunUp = parseSunUpJson(response.body.toString());
    
    
    if (response.statusCode == 200){
      return sunUp;
    }
    else{
      throw APIException('could not load data from sunrise api');
    }
  }

  SunUp parseSunUpJson(String jsonString) {
    String split1 = jsonString.split("results")[1];
    String split2 = split1.split("}")[0];
    String sunUpJson = "${split2.substring(2)}}";
    Map<String, dynamic> valuemap = json.decode(sunUpJson);
    return SunUp(
        valuemap["sunrise"], valuemap["sunset"], valuemap["day_length"]);
  }
}

void main() {
  ApiParser api = new ApiParser();
  var sun = api.getSunUp(57.71, 11.97);
}
