import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();
  final LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 10,
  );
  LatLng _currentLocation = LatLng(4.89, 114.942);
  LatLng? _selectedLocation;
  LatLng? _savedLocation;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _loadSavedLocation();
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if(permission == LocationPermission.denied) {
      return;
    }
    if(permission == LocationPermission.deniedForever) {
      return;
    }
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });
    _mapController.move(_currentLocation, _mapController.camera.zoom);
  }

  void _onMapTapped(LatLng point) {
    setState(() {
      _selectedLocation = point;
    });
  }

  void _clearSelectedLocation() {
    setState(() {
      _selectedLocation = null;
    });
  }

  void _getSelectedLocation() {
    if(_selectedLocation != null) {
      _mapController.move(_selectedLocation!, _mapController.camera.zoom);
    }
  }

  Future<void> _saveLocationToFirebase() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if(user != null) {
        LatLng savingLocation = _selectedLocation ?? _currentLocation;
        DocumentReference userDoc =
          FirebaseFirestore.instance.collection('users')
          .doc(user.uid);
        userDoc.update({
          'latitude': savingLocation.latitude,
          'longitude': savingLocation.longitude,
        });
        setState(() {
          _savedLocation = savingLocation;
          _selectedLocation = null;
        });
      }
    } catch (e) {

    }
  }

  Future<void> _loadSavedLocation() async {
    User? user = FirebaseAuth.instance.currentUser;
    if(user != null) {
      DocumentReference userDoc =
        FirebaseFirestore.instance.collection('users')
        .doc(user.uid);
      DocumentSnapshot userSnapshot = await userDoc.get();
      if(userSnapshot.exists) {
        setState(() {
          _savedLocation = LatLng(
            userSnapshot.get('latitude') as double,
            userSnapshot.get('longitude') as double,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Page'),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentLocation,
              initialZoom: 19.0,
              onTap: (tapPosition, point) => _onMapTapped(point),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                tileProvider: CancellableNetworkTileProvider(),
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _currentLocation,
                    child: Icon(
                      Icons.my_location,
                      color: Colors.blue,
                      size: 30,
                    ),
                  ),
                  if(_selectedLocation != null)
                    Marker(
                      point: _selectedLocation!,
                      child: Icon(
                        Icons.pin_drop,
                        color: Colors.red,
                        size: 30,
                      ),
                    ),
                  if(_savedLocation != null)
                    Marker(
                      point: _savedLocation!,
                      child: Icon(
                        Icons.location_on,
                        color: Colors.green,
                        size: 30,
                      ),
                    ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: _clearSelectedLocation,
                  child: const Text('Clear Selected Location'),
                ),
                ElevatedButton(
                  onPressed: _getCurrentLocation,
                  child: const Text('Current Location'),
                ),
                ElevatedButton(
                  onPressed: _getSelectedLocation,
                  child: const Text('Selected Location'),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: _saveLocationToFirebase,
              child: const Text('Save Location'),
            ),
          ),
        ],
      ),
    );
  }
}