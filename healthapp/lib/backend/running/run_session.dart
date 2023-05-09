import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

import 'dart:math' as math;

import '../location/location.dart';
import '../location/location_search.dart';

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

  bool isPaused() {
    return duration.inSeconds > 0;
  }

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
      log("distance is 0");
      return;
    }
    _avgMinPerKm = (duration.inSeconds / 60) / (_distance);
    
  }

  void calculateAvgMPerS() {
    if (duration.inSeconds == 0) {
      _avgKmPerHour = 0;
      return;
    }

    _avgKmPerHour = (_distance * 1000) / (duration.inSeconds);
  }

  void addToPath(LocationData data) {
    if (_path.isEmpty) {
      _path.add(data);
      return;
    }
    _distance += (Geolocator.distanceBetween(_path.last.latitude,
            _path.last.longitude, data.latitude, data.longitude) /
        1000);
    _path.add(data);
  }
}

class LocationTracker {
  late Location _location;
  late RunSession _runSession;
  late Timer _timeTimer;
  late StreamController<RunSession> _controller;
  late StreamSubscription<Position> streamPos;

  LocationTracker() {
    _runSession = RunSession();
    _controller = StreamController<RunSession>();
  }

  Future<void> startTracking() async {
    _location = await Location.getInstance();
    if (!_runSession.isPaused()) {
      _runSession = RunSession();
    }

    _controller.add(_runSession);

    streamPos = _location.getPosStream().listen((Position? position) {
      if (position != null) {
        final longitude = position.longitude;
        final latitude = position.latitude;
        final latLng = LocationData(latitude, longitude, '');
        _runSession.addToPath(latLng);
        _runSession.calculateAvgMPerS();
        _runSession.calculateAvgMinPerKm();
      }
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

  void pauseTracking() {
    _timeTimer.cancel();
    streamPos.cancel();
  }

  void stopTracking() {
    streamPos.cancel();
    _timeTimer.cancel();
    _controller.close();
    _runSession = RunSession(); // reset run session
  }

  RunSession getRunSession() {
    final endTime = DateTime.now();
    _runSession.duration = endTime.difference(_runSession.startTime);
    return _runSession;
  }
}
