import "package:flutter/material.dart";
import "../components/my_appbar.dart";
import 'package:geolocator/geolocator.dart';

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

Future<bool> _handleLocationPermission() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Check if location services are enabled
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return false;
  }

  // Check permission status
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

  return await Geolocator.getCurrentPosition();
}
