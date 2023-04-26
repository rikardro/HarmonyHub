class GreetingPhrase{

  static String get(){
    int hour = DateTime.now().hour;
    if(hour >= 5 && hour < 10){
        return  "Good Morning!";
    } else if(hour >= 10 && hour < 14){
        return "Good Day!";
    }else if(hour >= 14 && hour < 17){
        return "Good Afternoon!";
    } else if(hour >= 17 && hour < 23){
        return "Good Evening!";
    } else{
        return "Good Night!";
    }
  }
}