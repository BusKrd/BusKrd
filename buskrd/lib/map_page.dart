import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  LatLng mycurrentLoc = const LatLng(0, 0);
  late GoogleMapController googleMapController;
  bool isLoading = true;

  static const kaziwa = LatLng(35.5548, 45.4890);
  static const bazar = LatLng(35.55687498181495, 45.44398410702944);

  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  void _initializeMap() async {
    await _getInitialLocation();
    List<LatLng> coordinates = await polyLinePoints();
    generatePolylines(coordinates);
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
                    markerId: MarkerId('kaziwa'),
                    icon: BitmapDescriptor.defaultMarker,
                    position: kaziwa),
                Marker(
                    markerId: MarkerId('bazar'),
                    icon: BitmapDescriptor.defaultMarker,
                    position: bazar),
              },
              polylines: Set<Polyline>.of(polylines.values),
            ),
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

  Future<List<LatLng>> polyLinePoints() async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();

    var apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];

    print("Using API Key: $apiKey");

    PolylineRequest request = PolylineRequest(
      origin: PointLatLng(bazar.latitude, bazar.longitude),
      destination: PointLatLng(kaziwa.latitude, kaziwa.longitude),
      mode: TravelMode.driving,
    );

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      request: request,
      googleApiKey: apiKey,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    return polylineCoordinates;
  }

  void generatePolylines(List<LatLng> polylineCoordinates) async {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.red,
        points: polylineCoordinates,
        width: 3);
    setState(() {
      polylines[id] = polyline;
    });
  }
}
