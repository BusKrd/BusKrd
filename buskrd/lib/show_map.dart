import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class MapPageHome extends StatefulWidget {
   final LatLng? searchedLocation;
  const MapPageHome({super.key, this.searchedLocation});

  @override
  State<MapPageHome> createState() => _MapPageHomeState();
}

class _MapPageHomeState extends State<MapPageHome> {
  LatLng mycurrentLoc = const LatLng(0, 0);
  late GoogleMapController googleMapController;
  bool isLoading = true; // To show loading before fetching location

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  void _initializeMap() async {
    await _getInitialLocation();
    if (widget.searchedLocation != null) {
      _goToSearchedLocation(widget.searchedLocation!);
    } // Get current location
  }

  void _goToSearchedLocation(LatLng location) {
    googleMapController.animateCamera(
      CameraUpdate.newLatLng(location),
    );
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
          ? const Center(
              child:
                  CircularProgressIndicator()) // Show loading until location is fetched
          : GoogleMap(
              zoomControlsEnabled: false,
              myLocationEnabled:
                  true, // Enable the default "My Location" blue dot
              myLocationButtonEnabled:
                  true, // Enable the default "My Location" button
              initialCameraPosition:
                  CameraPosition(target: mycurrentLoc, zoom: 15),
              onMapCreated: (GoogleMapController controller) {
                googleMapController = controller;
              },
            ),
      // Add a Floating Action Button to center the map on the current location
      floatingActionButton: FloatingActionButton(
        onPressed: _goToCurrentLocation,
        child: const Icon(Icons.my_location),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat, // Position the FAB at the bottom left
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

  // Function to move the camera to the current location
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