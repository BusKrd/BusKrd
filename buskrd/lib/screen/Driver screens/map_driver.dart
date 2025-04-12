import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class MapPageDriver extends StatefulWidget {
  const MapPageDriver({super.key});

  @override
  State<MapPageDriver> createState() => _MapPageDriverState();
}

class _MapPageDriverState extends State<MapPageDriver> {
  LatLng mycurrentLoc = const LatLng(0, 0);
  late GoogleMapController googleMapController;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  void _initializeMap() async {
    await _getInitialLocation();
  }

  Future<void> _getInitialLocation() async {
    try {
      Position position = await _currentLocation();
      setState(() {
        mycurrentLoc = LatLng(position.latitude, position.longitude);
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              zoomControlsEnabled: false,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              initialCameraPosition:
                  CameraPosition(target: mycurrentLoc, zoom: 15),
              onMapCreated: (GoogleMapController controller) {
                googleMapController = controller;
              },
              markers: {
                  Marker(
                      markerId: MarkerId('current location'),
                      icon: BitmapDescriptor.defaultMarker,
                      position: mycurrentLoc),
                }),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToCurrentLocation,
        child: const Icon(Icons.my_location),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  Future<Position> _currentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }
    return await Geolocator.getCurrentPosition();
  }

  void _goToCurrentLocation() async {
    try {
      Position position = await _currentLocation();
      googleMapController.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(position.latitude, position.longitude),
        ),
      );
    } catch (e) {
      debugPrint("Error moving to current location: $e");
    }
  }
}
