import "package:flutter/material.dart";
import "../components/my_appbar.dart";
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


/*
class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  String _location = 'Unknown';

  Future<void> _updateLocation() async {
    try {
      Position position = await _getCurrentLocation();
      setState(() {
        _location = 'Lat: ${position.latitude}, Long: ${position.longitude}';
      });
    } catch (e) {
      setState(() {
        _location = 'Error: ${e.toString()}';
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

  Future<Position> _getCurrentLocation() async {
    bool hasPermission = await _handleLocationPermission();
    if (!hasPermission) return Future.error('Location permission not granted');

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Geolocator Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Current Location: $_location'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateLocation,
              child: Text('Get Location'),
            ),
          ],
        ),
      ),
    );
  }
}
*/