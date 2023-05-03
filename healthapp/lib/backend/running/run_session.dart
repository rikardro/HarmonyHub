import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthapp/backend/location/location_search.dart';

import '../location/location.dart';

import 'dart:math' as math;

class RunSession {
  String? userId;
  DateTime startTime;
  Duration duration;
  List<LocationData> _path;
  double _distance = 0;
  double _avgMinPerKm = 0;
  double _avgKmPerHour = 0;

  RunSession()
      : startTime = DateTime.now(),
        duration = Duration.zero,
        _path = [];

  List<LocationData> get path => _path;

  double getDistance() {
    return _distance;
  }

  double getAvgMinPerKm() {
    return _avgMinPerKm;
  }

  double getAvgKmPerHour() {
    return _avgKmPerHour;
  }

  void calculateAvgMinPerKm() {
    if (_distance == 0) {
      _avgMinPerKm = 0;
      return;
    }
    _avgMinPerKm = duration.inMinutes / (_distance / 1000);
    _avgMinPerKm;
  }

  void calculateAvgKmPerHour() {
    if (duration.inSeconds == 0) {
      _avgKmPerHour = 0;
      return;
    }
    _avgKmPerHour = (_distance / 1000) / (duration.inSeconds / 3600);
    _avgKmPerHour;
  }

  void addToPath(LocationData data) {
    if (_path.isEmpty) {
      _path.add(data);
      return;
    }
    _distance += _distanceBetween(_path.last, data);
    _path.add(data);
  }

  double _distanceBetween(LocationData start, LocationData end) {
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
  late Timer _locationTimer;
  late Timer _timeTimer;
  late StreamController<RunSession> _controller;

  LocationTracker() {
    _controller = StreamController<RunSession>();
  }

  Future<void> startTracking() async {
    _location = await Location.getInstance();
    _runSession = RunSession();
    _locationTimer =
        Timer.periodic(const Duration(seconds: 3), (Timer timer) async {
      _location.determinePosition();
      final longitude = _location.longitude;
      final latitude = _location.latitude;
      final latLng = LocationData(latitude, longitude, '');
      _runSession.addToPath(latLng);
      _runSession.calculateAvgKmPerHour();
      _runSession.calculateAvgMinPerKm();
    });

    _timeTimer =
        Timer.periodic(const Duration(seconds: 1), (Timer timer) async {
      _runSession.duration += const Duration(seconds: 1);
      _controller.add(_runSession);
    });
  }

  Stream<RunSession> getStream() {
    return _controller.stream;
  }

  void stopTracking() {
    _locationTimer.cancel();
    _controller.close();
  }

  RunSession getRunSession() {
    final endTime = DateTime.now();
    _runSession.duration = endTime.difference(_runSession.startTime);
    return _runSession;
  }

  pauseTracking() {}
}
