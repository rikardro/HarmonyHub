enum WeatherType { cloudy, clear, foggy, snowing, raining, halfCloudy }

extension ParseToString on WeatherType {
  String toShortString() {
    return this.toString().split('.').last;
  }
}