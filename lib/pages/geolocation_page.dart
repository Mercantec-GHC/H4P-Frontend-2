import 'package:fiske_fitness_app/pages/home_page.dart';
import "package:flutter/material.dart";
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  List<LatLng> _routePoints = [];
  Completer<GoogleMapController> _mapController = Completer();
  bool _isMapControllerCompleted = false; // Flag for Completer
  StreamSubscription<Position>? _positionStreamSubscription;
  bool _isTracking = false;
  double _totalDistance = 0.0;
  bool _hasStartedTracking = false; // New state variable

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _stopTracking();
    if (!_isMapControllerCompleted) {
      _mapController.completeError(Exception("Map controller is disposed"));
      _isMapControllerCompleted = true;
    }
    super.dispose();
  }

  void _startTracking() async {
    if (_isTracking) return;

    bool hasPermission = await _handleLocationPermission();
    if (hasPermission && mounted) {
      setState(() {
        _isTracking = true;
        _hasStartedTracking = true; // Set this to true when tracking starts
      });

      LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      );

      _positionStreamSubscription = Geolocator.getPositionStream(
        locationSettings: locationSettings,
      ).listen((Position position) {
        if (mounted) {
          setState(() {
            if (_routePoints.isNotEmpty) {
              LatLng lastPoint = _routePoints.last;
              double distance = Geolocator.distanceBetween(
                lastPoint.latitude,
                lastPoint.longitude,
                position.latitude,
                position.longitude,
              );

              _totalDistance += distance;
            }

            _routePoints.add(LatLng(position.latitude, position.longitude));
          });

          _updateMap();
        }
      });
    }
  }

  void _stopTracking() async {
    // Cancel the position stream subscription
    await _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;

    // Use a check to ensure the widget is still mounted before calling setState
    if (mounted) {
      setState(() {
        _isTracking = false; // Update the local variable with setState
      });
    }
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }

    if (permission == LocationPermission.deniedForever) return false;

    return true;
  }

  void _updateMap() async {
    if (_routePoints.isNotEmpty && mounted) {
      final GoogleMapController? controller = await _mapController.future;
      if (controller != null) {
        LatLngBounds bounds = _calculateBounds();
        controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
      }
    }
  }

  LatLngBounds _calculateBounds() {
    if (_routePoints.isEmpty) {
      return LatLngBounds(
        northeast: LatLng(0, 0),
        southwest: LatLng(0, 0),
      );
    }

    double minLat = _routePoints[0].latitude;
    double maxLat = _routePoints[0].latitude;
    double minLng = _routePoints[0].longitude;
    double maxLng = _routePoints[0].longitude;

    for (LatLng point in _routePoints) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    return LatLngBounds(
      northeast: LatLng(maxLat, maxLng),
      southwest: LatLng(minLat, minLng),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6cbabc),
      appBar: AppBar(
        backgroundColor: const Color(0xFFcacdce),
        title: Text('Running Tracker'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(0, 0),
                zoom: 2,
              ),
              onMapCreated: (GoogleMapController controller) {
                if (mounted) {
                  _mapController.complete(controller);
                  _isMapControllerCompleted = true; // Set the flag here
                }
              },
              polylines: {
                Polyline(
                  polylineId: PolylineId('route'),
                  points: _routePoints,
                  color: Colors.blue,
                  width: 5,
                ),
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Distance: ${_totalDistance.toStringAsFixed(2)} meters',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!_hasStartedTracking) // Show only if tracking hasn't started
                      ElevatedButton(
                        onPressed: _startTracking,
                        child: Text('Start Tracking'),
                      ),
                    if (_hasStartedTracking) // Show only if tracking has started
                      ...[
                      ElevatedButton(
                        onPressed: _isTracking ? _stopTracking : null,
                        child: Text('Stop Tracking'),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/*
class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  List<LatLng> _routePoints = [];
  Completer<GoogleMapController> _mapController = Completer();
  bool _isMapControllerCompleted = false; // Flag for Completer
  StreamSubscription<Position>? _positionStreamSubscription;
  bool _isTracking = false;
  double _totalDistance = 0.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _stopTracking();
    if (!_isMapControllerCompleted) {
      _mapController.completeError(Exception("Map controller is disposed"));
      _isMapControllerCompleted = true;
    }
    super.dispose();
  }

  void _startTracking() async {
    if (_isTracking) return;

    bool hasPermission = await _handleLocationPermission();
    if (hasPermission && mounted) {
      setState(() {
        _isTracking = true;
      });

      LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      );

      _positionStreamSubscription = Geolocator.getPositionStream(
        locationSettings: locationSettings,
      ).listen((Position position) {
        if (mounted) {
          setState(() {
            if (_routePoints.isNotEmpty) {
              LatLng lastPoint = _routePoints.last;
              double distance = Geolocator.distanceBetween(
                lastPoint.latitude,
                lastPoint.longitude,
                position.latitude,
                position.longitude,
              );

              _totalDistance += distance;
            }

            _routePoints.add(LatLng(position.latitude, position.longitude));
          });

          _updateMap();
        }
      });
    }
  }

  void _stopTracking() {
    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
    // No need for setState here
    _isTracking = false; // Just update the local variable
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }

    if (permission == LocationPermission.deniedForever) return false;

    return true;
  }

  void _updateMap() async {
    if (_routePoints.isNotEmpty && mounted) {
      final GoogleMapController? controller = await _mapController.future;
      if (controller != null) {
        LatLngBounds bounds = _calculateBounds();
        controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
      }
    }
  }

  LatLngBounds _calculateBounds() {
    if (_routePoints.isEmpty) {
      return LatLngBounds(
        northeast: LatLng(0, 0),
        southwest: LatLng(0, 0),
      );
    }

    double minLat = _routePoints[0].latitude;
    double maxLat = _routePoints[0].latitude;
    double minLng = _routePoints[0].longitude;
    double maxLng = _routePoints[0].longitude;

    for (LatLng point in _routePoints) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    return LatLngBounds(
      northeast: LatLng(maxLat, maxLng),
      southwest: LatLng(minLat, minLng),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6cbabc),
      appBar: AppBar(
        backgroundColor: const Color(0xFFcacdce),
        title: Text('Running Tracker'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(0, 0),
                zoom: 2,
              ),
              onMapCreated: (GoogleMapController controller) {
                if (mounted) {
                  _mapController.complete(controller);
                  _isMapControllerCompleted = true; // Set the flag here
                }
              },
              polylines: {
                Polyline(
                  polylineId: PolylineId('route'),
                  points: _routePoints,
                  color: Colors.blue,
                  width: 5,
                ),
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Distance: ${_totalDistance.toStringAsFixed(2)} meters',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _isTracking ? null : _startTracking,
                      child: Text('Start Tracking'),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: _isTracking ? _stopTracking : null,
                      child: Text('Stop Tracking'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
*/