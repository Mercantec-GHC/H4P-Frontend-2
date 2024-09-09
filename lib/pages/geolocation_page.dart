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
  StreamSubscription<Position>? _positionStreamSubscription;
  bool _isTracking = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _stopTracking();
    _mapController.future.then((controller) {
      if (mounted) {
        controller.dispose();
      }
    }).catchError((error) {
      // Catch any errors if the controller has already been disposed
    });
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
        if (!mounted) return; // Prevent updating if widget is not mounted

        setState(() {
          _routePoints.add(LatLng(position.latitude, position.longitude));
        });

        _updateMap();
      });
    }
  }

  void _stopTracking() {
    if (_positionStreamSubscription != null) {
      _positionStreamSubscription!.cancel();
      _positionStreamSubscription = null;
    }
    if (mounted) {
      setState(() {
        _isTracking = false;
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
      final GoogleMapController controller = await _mapController.future;
      if (!mounted) return;

      LatLngBounds bounds = _calculateBounds();
      if (mounted) {
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

  Future<bool> _onWillPop(BuildContext context) async {
    _stopTracking(); // Ensure tracking stops when user leaves
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        bool canPop = await _onWillPop(context);
        if (canPop) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
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
                  if (!mounted) return;
                  _mapController.complete(controller);
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
              child: Row(
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
            ),
          ],
        ),
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
  StreamSubscription<Position>? _positionStreamSubscription;

  @override
  void initState() {
    super.initState();
    _startTracking();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  void _startTracking() async {
    bool hasPermission = await _handleLocationPermission();
    if (hasPermission) {
      LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high, // High accuracy for precise tracking
        distanceFilter: 10, // Minimum distance (in meters) before an update
      );
      _positionStreamSubscription = Geolocator.getPositionStream(
        locationSettings: locationSettings,
      ).listen((Position position) {
        setState(() {
          _routePoints.add(LatLng(position.latitude, position.longitude));
        });
        _updateMap();
      });
    }
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  void _updateMap() async {
    if (_routePoints.isNotEmpty) {
      final GoogleMapController controller = await _mapController.future;
      LatLngBounds bounds = _calculateBounds();
      controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
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
      appBar: AppBar(
        title: Text('Running Tracker'),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(0, 0),
          zoom: 2,
        ),
        onMapCreated: (GoogleMapController controller) {
          _mapController.complete(controller);
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
    );
  }
}


*/