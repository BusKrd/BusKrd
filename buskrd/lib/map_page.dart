import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  LatLng mycurrentLoc = const LatLng(20.5937, 78.9629); // Default: India
  late GoogleMapController googleMapController;
  bool isLoading = true; // To show loading before fetching location
  String googleMapsApiKey='AIzaSyB13fMIAxQnhW5TVWrah0KsZnI1yeJqoQI';
  static const kaziwa= LatLng(35.5548, 45.4890);
  static const bazar= LatLng(35.55687498181495, 45.44398410702944);
  

  @override
  void initState() {
    super.initState();
    _getInitialLocation();
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
          ? const Center(child: CircularProgressIndicator()) // Show loading until location is fetched
          : GoogleMap(
              myLocationEnabled: true, // Enable the default "My Location" blue dot
              myLocationButtonEnabled: true, // Enable the default "My Location" button
              initialCameraPosition: CameraPosition(target: mycurrentLoc, zoom: 15),
              onMapCreated: (GoogleMapController controller) {
                googleMapController = controller;
              },
              markers:{
            Marker(markerId: MarkerId('kaziwa'),
            icon: BitmapDescriptor.defaultMarker,
            position: kaziwa),

            Marker(markerId: MarkerId('bazar'),
            icon: BitmapDescriptor.defaultMarker,
            position: bazar),
          },
        
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Position position = await _currentLocation();
          googleMapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(position.latitude, position.longitude),
                zoom: 15,
              ),
            ),
          );
          
        },
        child: const Icon(Icons.location_searching_outlined),
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
}