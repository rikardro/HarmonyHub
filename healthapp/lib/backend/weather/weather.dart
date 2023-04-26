// Gets the information from the api in json format and parses it to a dart object
import 'dart:convert';
import 'package:healthapp/backend/weather/customExceptions.dart';
import 'package:healthapp/backend/weather/parseJson.dart';
import 'package:healthapp/backend/weather/sunUp.dart';
import 'package:healthapp/util/weatherInformation.dart';
import 'package:healthapp/util/weatherType.dart';
import 'package:healthapp/weekly_weather/weekly_weather_card.dart';
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
  Future<WeatherInformationCurrent> requestCurrentWeather(
      double latitude, double longitude) async {
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
      WeatherInformationCurrent now = WeatherInformationCurrent(
          wi.time,
          wi.temperature,
          wi.precipitation,
          wi.snowfall,
          wi.snow_depth,
          wi.weather,
          wi.cloudcover,
          wi.windspeed,
          wi.windDegrees);
      bool sunUp = await getSunUp(latitude, longitude);
      now.setsun_up(sunUp);
      return now;
    } else {
      throw APIException('could not load data from Meteo weather API');
    }
  }

  Future<List<WeatherInformationWeekly>> requestWeeklyWeather(
      double latitude, double longitude) async {
    String request =
        "?latitude=$latitude&longitude=$longitude&daily=weathercode,temperature_2m_max,temperature_2m_min,precipitation_sum,windspeed_10m_max&windspeed_unit=ms&timezone=Europe%2FBerlin";
    var url =
        Uri.parse(ApiConstants.baseUrl + ApiConstants.usersEndpoint + request);
    var response = await http.get(url);
    Map<String, dynamic> valueMap = json.decode(response.body);
    JsonParserWeekly parser = JsonParserWeekly();
    List<WeatherInformationWeekly> weatherInformation =
        parser.jsonWeeklyDataConverter(valueMap);
    return weatherInformation;
  }

  Future<bool> getSunUp(double latitude, double longitude) async {
    String request = "lat=$latitude&lng=$longitude&timezone=EET&date=today";
    var url = Uri.parse(ApiConstants.sunsetSunrise + request);
    var response = await http.get(url);
    SunUp sunUp = parseSunUpJson(response.body.toString());
    var time = DateTime.now();
    double currentTime = (time.hour + time.minute / 60);

    if (response.statusCode == 200) {
      return sunUp.sunIsUp(currentTime);
    } else {
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

void main() async{
  ApiParser api = new ApiParser();
  List<WeatherInformationWeekly> weather = await api.requestWeeklyWeather(57.71, 11.97);
}
