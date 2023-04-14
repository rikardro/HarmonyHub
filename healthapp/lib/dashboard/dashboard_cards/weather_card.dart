import 'package:flutter/material.dart';
import 'package:healthapp/util/weatherType.dart';
import '../../backend/weather/weather.dart';
import '../../util/weatherInformation.dart';
import '../dashboard_card.dart';

class WeatherCard extends StatelessWidget {
   WeatherCard( {Key? key,}) : super(key: key);

  AssetImage weatherImage(weather) {
    switch (weather) {
      case ("Sunny"):
        {
          return const AssetImage('assets/images/clear_day.png');
        }
      case ("Rainy"):
        {
          return const AssetImage('assets/images/raining.png');
        }
      case ("cloudy"):
        {
          return const AssetImage('assets/images/cloudy.png');
        }
      case ("Foggy"):
        {
          return const AssetImage('assets/images/foggy.png');
        }
      case ("Half cloudy"):
        {
          return const AssetImage('assets/images/halfcloudy_day.png');
        }
      case ("Snowing"):
        {
          return const AssetImage('assets/images/snowing.png');
        }
      default:
        {
          return const AssetImage('assets/images/clear_day.png');
        }
    }
  }

  Color weatherColor(weather) {
    switch (weather) {
      case ("Sunny"):
        {
          return const Color(0xFFFF9900);
        }
      case ("Rainy"):
        {
          return const Color.fromARGB(255, 137, 192, 255);
        }
      case ("cloudy"):
        {
          return const Color.fromARGB(255, 152, 166, 182);
        }
      case ("Foggy"):
        {
          return const Color.fromARGB(255, 194, 223, 255);
        }
      case ("Half cloudy"):
        {
          return const Color.fromARGB(255, 255, 216, 143);
        }
      case ("Snowing"):
        {
          return const Color.fromARGB(255, 203, 210, 255);
        }
      default:
        {
          return const Color.fromARGB(255, 114, 180, 255);
        }
    }
  }

  Future<WeatherInformation> fetchWeatherData() async {
    ApiParser apiParser = ApiParser();
    WeatherInformation wi = await apiParser.requestCurrentWeather(57.71, 11.97);
    return wi;
  }

  @override
  Widget build(BuildContext context) {

    final baseTextStyle = TextStyle(
      color: Colors.white,
      fontSize: 15,
      fontFamily: 'Inter',
      shadows: [
        Shadow(
          blurRadius: 10,
          offset: const Offset(2, 2),
          color: Colors.black.withOpacity(0.3),
        ),
      ],
    );

    return FutureBuilder(
      future: fetchWeatherData(),
      builder: (context, AsyncSnapshot<WeatherInformation> weatherData){
        if(weatherData.hasData){
        return DashboardCard(
          flex: 12, color: weatherColor(weatherData.data!.weatherType.toShortString()),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(image: weatherImage(weatherData.data!.weatherType.toShortString()),
                  width: 100)
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(weatherData.data!.weatherType.toShortString(), style: TextStyle(fontSize: 25, color: baseTextStyle.color, fontFamily: baseTextStyle.fontFamily, shadows: baseTextStyle.shadows, fontWeight: FontWeight.w500)),
                        Text("${weatherData.data!.temperature} °C", style: TextStyle(fontSize: 20, color: baseTextStyle.color, fontFamily: baseTextStyle.fontFamily, shadows: baseTextStyle.shadows)),
                        Text("${weatherData.data!.windspeed} m/s", style: TextStyle(fontSize: 16, color: baseTextStyle.color, fontFamily: baseTextStyle.fontFamily, shadows: baseTextStyle.shadows))
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ));
      }else{
        return const DashboardCard(flex: 12, color: Color(0xFFFF9900),child: Text("Kunde inte ladda vädret"));
      }});
    
    
  }
}
