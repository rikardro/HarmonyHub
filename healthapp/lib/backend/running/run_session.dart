import 'dart:async';

import 'package:healthapp/backend/location/location_search.dart';

import '../location/location.dart';

import 'dart:math' as math;

class RunSession {
  DateTime startTime;
  Duration duration;
  List<LocationData> _path;
  double _distance = 0;

  RunSession()
      : startTime = DateTime.now(),
        duration = Duration.zero,
        _path = [];

  void addToPath(LocationData data) {
    if (_path.isEmpty) {
      _path.add(data);
      return;
    }
    _distance += distanceBetween(_path.last, data);
    _path.add(data);
  }

  double distanceBetween(LocationData start, LocationData end) {
    const int radius = 6371000; // Earth's radius in meters
    final double lat1 = start.latitude * math.pi / 180;
    final double lat2 = end.latitude * math.pi / 180;
    final double deltaLat = (end.latitude - start.latitude) * math.pi / 180;
    final double deltaLng = (end.longitude - start.longitude) * math.pi / 180;

    final double a = math.sin(deltaLat / 2) * math.sin(deltaLat / 2) +
        math.cos(lat1) *
            math.cos(lat2) *
            math.sin(deltaLng / 2) *
            math.sin(deltaLng / 2);

    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return radius * c;
  }
}

class LocationTracker {
  late Location _location;
  late RunSession _runSession;
  late Timer _timer;
  late StreamController<RunSession> _controller;

  LocationTracker() {
    _controller = StreamController<RunSession>();
  }

  Future<void> startTracking() async {
    _location = await Location.getInstance();
    _runSession = RunSession();
    const Duration duration = Duration(seconds: 3);
    _timer = Timer.periodic(duration, (Timer timer) async {
      _location.determinePosition();
      final longitude = _location.longitude;
      final latitude = _location.latitude;
      final latLng = LocationData(latitude, longitude, '');
      _runSession.addToPath(latLng);
      _controller.add(_runSession);
      print("SWA");
    });
  }

  Stream<RunSession> getStream() {
    return _controller.stream;
  }

  void stopTracking() {
    _timer.cancel();
    _controller.close();
  }

  RunSession getRunSession() {
    final endTime = DateTime.now();
    _runSession.duration = endTime.difference(_runSession.startTime);
    return _runSession;
  }
}
