import 'package:healthapp/backend/weather/weather.dart';

import '../../util/weatherInformation.dart';
import '../../util/weatherType.dart';

class RecommendedDaysRepo {
  final ApiParser apiClient;

  RecommendedDaysRepo({required this.apiClient}) : assert(apiClient != null);

  double calculatePoints(WeatherInformation weatherData, {int idealTemperature = 18}) {
    double points = 0;

    // Wind
    points -= (weatherData.windspeed / 3).floor();

    // Temperature
    points -= (weatherData.temperature - idealTemperature).abs().round();

    // Snow depth
    if (weatherData.snow_depth > 0) {
      points -= 10;
    }

    // Weather type
    Map<WeatherType, int> weatherTypePoints = {
      WeatherType.clear: 5,
      WeatherType.cloudy: 0,
      WeatherType.foggy: -1,
      WeatherType.halfCloudy: 3,
      WeatherType.raining: -3,
      WeatherType.snowing: 0
    };
    points += weatherTypePoints[weatherData.weather] ?? 0;

    // Precipitation
    points -= weatherData.precipitation.round();

    // Since humidity is not available in the provided class, it has been omitted from the calculation.

    // Air quality (AQI) is also not available in the provided class, so it has been omitted from the calculation.

    return points;
  }

  // Cluster times into intervals
  List<List<RecommendedTime>> clusterTimes(List<RecommendedTime> recommendedTimes){
    List<List<RecommendedTime>> clusters = [];
    List<RecommendedTime> currentCluster = [];
    for(int i = 0; i < recommendedTimes.length; i++){
      DateTime date = DateTime.parse(recommendedTimes[i].weather.time);

      DateTime startTime = DateTime(date.year, date.month, date.day, 4, 59);
      DateTime endTime = DateTime(date.year, date.month, date.day, 22, 01);

      if (date.isAfter(startTime) && date.isBefore(endTime)) {
        if(currentCluster.isEmpty){
          currentCluster.add(recommendedTimes[i]);
        }
        else if((currentCluster.last.points - recommendedTimes[i].points).abs() <= 2){
          currentCluster.add(recommendedTimes[i]);
        } else if(currentCluster.isNotEmpty){
          clusters.add(currentCluster.toList());
          currentCluster.clear();
        }
      } else {
        print('The time is not between 05:00 and 22:00');
      }
    }
    
    return clusters;
  }

  Future<List<RecommendedIntervals>> getRecommended() async{
    final apiClient = ApiParser();

    List<WeatherInformation> weatherList = await apiClient.requestWeather(57.7085865,11.9684324);
    List<RecommendedTime> recommended = [];
    for (WeatherInformation weather in weatherList) {
      double points = await calculatePoints(weather);
      recommended.add(RecommendedTime(weather, points));
    }

    final List<List<RecommendedTime>> clusters = clusterTimes(recommended);

    // Sort clusters by the average points in descending order
    clusters.sort((a, b) => b.fold(0, (sum, e) => sum + e.points.truncate()) ~/ b.length 
                  - a.fold(0, (sum, e) => sum + e.points.truncate()) ~/ a.length);

    List<List<RecommendedTime>> topClusters = clusters.take(5).toList();
    List<RecommendedIntervals> recommendedIntervals = [];
    for (List<RecommendedTime> cluster in topClusters) {
      recommendedIntervals.add(RecommendedIntervals(
        DateTime.parse(cluster.first.weather.time),
        DateTime.parse(cluster.last.weather.time),
        // Get average temperature
        cluster.fold(0, (sum, e) => sum + e.weather.temperature.truncate()) / cluster.length,
        cluster.fold(0, (sum, e) => sum + e.weather.windspeed.truncate()) / cluster.length,
        cluster.fold(0, (sum, e) => sum + e.weather.precipitation.truncate()) / cluster.length,
        cluster.map((x) => x.weather.weather).toSet()
      ));
    }

    return recommendedIntervals;
  }

}

class RecommendedTime{
  final WeatherInformation weather;
  final double points;

  RecommendedTime(this.weather, this.points);
}

// For the frontend
class RecommendedIntervals{
  final DateTime startTime;
  final DateTime endTime;
  final double temperature;
  final double windspeed;
  final double precipitation;
  final Set<WeatherType> weatherTypes;

  RecommendedIntervals(this.startTime, this.endTime, this.temperature, this.windspeed, this.precipitation, this.weatherTypes);
}