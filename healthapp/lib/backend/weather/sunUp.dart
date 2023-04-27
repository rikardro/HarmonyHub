class SunUp{
  final String _sunrise;
  final String _sunset;
  final String _day_length;

  SunUp(this._sunrise, this._sunset, this._day_length);
  
  get sunrise => _sunrise;
  get sunset => _sunset;
  get day_length => _day_length;
  
  double _timeToDouble(String time){
    String timeCode = time.split(" ")[1];
    List<String> splitTime = time.split(":");
    int hour = int.parse(splitTime[0]);
    int minutes = int.parse(splitTime[1]);
    if (timeCode == "PM"){
      hour += 12;
    }
    return hour + minutes/60;
  }

  bool sunIsUp(double time){
    double rise = _timeToDouble(_sunrise);
    double down = _timeToDouble(_sunset);
    if(time >= rise){
      return time < down;
    }
    return false;
  }

  bool currentSunIsUp() {
    var time = DateTime.now();
    double currentTime = (time.hour + time.minute/60);
    return sunIsUp(currentTime);
  }

}