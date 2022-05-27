import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';


class SetLocationMapScreen extends StatefulWidget {
  const SetLocationMapScreen({Key? key}) : super(key: key);

  @override
  State<SetLocationMapScreen> createState() => _SetLocationMapScreenState();
}

class _SetLocationMapScreenState extends State<SetLocationMapScreen> {

  late GoogleMapController _googleMapController;
  static const _initialPosition = CameraPosition(target: LatLng(7.2906, 80.6337),zoom: 10);
  late LatLng _selectedLocation;

  final Set<Marker> _markers = {};

  static const Marker _marker = Marker(
    markerId: MarkerId("marker1"),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(7.2906,80.6337),
  );

  void _onMapCreated(GoogleMapController controller) {
    _googleMapController = controller;
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }
    Position _position = await Geolocator.getCurrentPosition();
    setState(() {
      _markers.add(Marker(markerId: const MarkerId('mark'), position: LatLng(_position.latitude,_position.longitude)));
    });
    _googleMapController.animateCamera(CameraUpdate.newLatLngZoom(LatLng(_position.latitude,_position.longitude), 12));

  }

  @override
  void initState() {
    _determinePosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Location"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  mapType: MapType.normal,
                  initialCameraPosition: _initialPosition,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  markers: Set<Marker>.of(_markers),
                  onTap: (LatLng latLng) {
                    _markers.add(Marker(markerId: const MarkerId('mark'), position: latLng));
                    setState(() {
                      print(latLng);
                      _selectedLocation = LatLng(latLng.latitude, latLng.longitude);
                    });
                  } ,
                )
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: (){
                      print(_selectedLocation.latitude);
                      print(_selectedLocation.longitude);
                      Navigator.pop(context, _selectedLocation);
                    },
                    child: const Text("Select Marked Location"),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }
}