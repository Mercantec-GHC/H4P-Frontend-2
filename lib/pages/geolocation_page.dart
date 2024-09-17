import 'package:fiske_fitness_app/components/my_button.dart';
import "package:flutter/material.dart";
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
  bool _hasStoppedTracking = false; // New state variable
  DateTime? _startTime; // Tracks the start time
  double _currentPace = 0.0; // Stores the calculated pace (in minutes per km)

/*
  @override
  void initState() {
    super.initState();
  }
*/

  @override
  void dispose() {
    _stopTracking();
    if (!_isMapControllerCompleted) {
      _mapController.completeError(Exception("Map controller is disposed"));
      _isMapControllerCompleted = true;
    }
    super.dispose();
  }

  void _onNewPosition(Position position) {
    if (_routePoints.isEmpty || _isPositionValid(position)) {
      setState(() {
        LatLng newPoint = LatLng(position.latitude, position.longitude);

        if (_routePoints.isNotEmpty) {
          LatLng lastPoint = _routePoints.last;
          double distance = Geolocator.distanceBetween(
            lastPoint.latitude,
            lastPoint.longitude,
            position.latitude,
            position.longitude,
          );

          if (distance > 5) {
            // Only add points if the distance is more than 5 meters
            _totalDistance += distance;
            _routePoints.add(newPoint);
          }
        } else {
          _routePoints.add(newPoint);
        }
      });
    }
  }

  Future<void> _sendTrackingData() async {
    final storage = const FlutterSecureStorage();
    final String? jwtToken = await storage.read(key: 'jwt');
    final url = Uri.parse(
        'https://fiskeprojekt-gruppe2.vercel.app/api/competitions/progress');
    final data = {
      'progress': _totalDistance.toString(),
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: data,
      );

      if (response.statusCode == 200) {
        print('Progress sent successfully.');
      } else {
        print('Failed to send progress: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending progress: $e');
    }
  }

  bool _isPositionValid(Position newPos) {
    if (_routePoints.isEmpty) return true;

    LatLng lastPoint = _routePoints.last;
    double distance = Geolocator.distanceBetween(
      lastPoint.latitude,
      lastPoint.longitude,
      newPos.latitude,
      newPos.longitude,
    );

    return distance > 5 && distance < 100; // Ignore erratic points
  }

  void _startTracking() async {
    if (_isTracking) return;

    bool hasPermission = await _handleLocationPermission();
    if (hasPermission && mounted) {
      setState(() {
        _isTracking = true;
        _hasStartedTracking = true; // Set this to true when tracking starts
        _hasStoppedTracking = false; // Reset the stop tracking flag
        _startTime = DateTime.now(); // Store the start time
      });

      LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 5,
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

            // Calculate and update pace
            _calculatePace();
          });

          _updateMap();
        }
      });
    }
  }

  void _stopTracking() async {
    if (_positionStreamSubscription == null) return; // Prevent multiple calls

    // Cancel the position stream subscription
    await _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;

    await _sendTrackingData(); // Send progress (distance) when stopping tracking

    if (mounted) {
      setState(() {
        _isTracking = false;
        _hasStoppedTracking = true; // Set this to true when tracking stops
      });
    }
  }

  void _calculatePace() {
    if (_totalDistance > 0 && _startTime != null) {
      final elapsedTime = DateTime.now().difference(_startTime!);
      final totalMinutes = elapsedTime.inSeconds / 60.0;
      final distanceInKilometers = _totalDistance / 1000.0;

      // Pace: Minutes per kilometer
      setState(() {
        _currentPace = totalMinutes / distanceInKilometers;
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
                if (_totalDistance > 0)
                  Text(
                    'Pace: ${_currentPace.toStringAsFixed(2)} min/km',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                SizedBox(height: 10),
                if (_hasStoppedTracking) // Show only if tracking has stopped
                  Text(
                    'Finished Tracking',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!_hasStartedTracking) // Show only if tracking hasn't started
                      MyButton(
                        onTap: _startTracking,
                        text: 'Start Tracking',
                      ),
                    if (_hasStartedTracking &&
                        !_hasStoppedTracking) // Show only if tracking has started and not stopped
                      MyButton(
                        onTap: _isTracking ? _stopTracking : null,
                        text: 'Stop Tracking',
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
