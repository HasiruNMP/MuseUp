import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:musicianapp/models/profile_model.dart';
import 'package:musicianapp/screens/account/uploadphoto_screen.dart';
import 'package:musicianapp/screens/account/uploadvideo_screen.dart';

class SetLocationScreen extends StatefulWidget {
  const SetLocationScreen({Key? key}) : super(key: key);

  @override
  State<SetLocationScreen> createState() => _SetLocationScreenState();
}

class _SetLocationScreenState extends State<SetLocationScreen> {

  late double selectedLocation;
  String selectedLocationName = '-';
  String country = '';
  String city = '';
  late LatLng currentLocation;
  final tecCountry = TextEditingController();
  final tecCity = TextEditingController();

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Your Location'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Determining Your Location',textAlign: TextAlign.center,),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      child: SpinKitRipple(
                        color: Colors.black38,
                        size: 100.0,
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(selectedLocationName),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: tecCountry,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Country',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: tecCity,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'City/District',
                      ),
                    ),
                  ),
                  SizedBox(height: 50,),
                  TextButton(
                    onPressed: (){
                      _navigateToMap(context);
                    },
                    child: Text("Set Location Manually"),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: (){
                        Profile().addLocation(currentLocation,tecCountry.text,tecCity.text);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const UploadPhotoScreen()),
                        );
                      },
                      child: Text('CONTINUE'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _navigateToMap(BuildContext context) async {
    final result = await Navigator.pushNamed(context, 'set-location-map');
    currentLocation = result as LatLng;
    List<Placemark> placeMarks = await placemarkFromCoordinates(currentLocation.latitude,currentLocation.longitude);
    setState(() {
      selectedLocationName = placeMarks[0].country! + " " + placeMarks[0].subAdministrativeArea!;
      tecCountry.text = placeMarks[0].country!;
      tecCity.text = placeMarks[0].subAdministrativeArea!;
    });
    print(result);

  }

  Future<void> getCurrentLocation() async {
    Position position = await _determinePosition();
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    currentLocation = LatLng(position.latitude, position.longitude);
    setState(() {
      selectedLocationName = placemarks[0].country! + " " + placemarks[0].subAdministrativeArea!;
      tecCountry.text = placemarks[0].country!;
      tecCity.text = placemarks[0].subAdministrativeArea!;
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }

  Future<void> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}