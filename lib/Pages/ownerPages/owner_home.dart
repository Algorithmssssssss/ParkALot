// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_final_fields, unused_field, unnecessary_new
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// pages imports
import 'package:park_alot/Pages/home.dart';
import 'package:park_alot/Pages/maps.dart';
import 'package:park_alot/Pages/ownerPages/add_locations.dart';
import 'package:park_alot/Pages/profile.dart';
import 'package:park_alot/Pages/search.dart';
import '../../util/my_button.dart';
import '../notification.dart';
import 'get_parking_data.dart';
import 'owner_list.dart';

// maps imports
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_location_picker/map_location_picker.dart';

class ownerHomePage extends StatefulWidget {
  const ownerHomePage({Key? key}) : super(key: key);

  @override
  State<ownerHomePage> createState() => _ownerHomePageState();
}

class _ownerHomePageState extends State<ownerHomePage> {
  final user = FirebaseAuth.instance.currentUser;
  List<String> docParkingIDs = [];
  late GoogleMapController mapController;
  late Marker _origin;
  late Marker _destination;

  final List<Marker> _markers = <Marker>[
    Marker(
      markerId: MarkerId('1'),
      position: LatLng(54.898772, 23.902762),
      infoWindow: InfoWindow(
        title: 'My House',
      ),
    ),
    Marker(
      markerId: MarkerId('2'),
      position: LatLng(54.8985, 23.9036),
      infoWindow: InfoWindow(title: 'Parking 1'),
    ),
  ];

  final LatLng _center = const LatLng(54.8985, 23.9036);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR" + error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 198, 220, 228),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => addLocationPage()),
          );
        },
        backgroundColor: Color.fromARGB(255, 109, 139, 116),
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ownerHomePage()),
                );
              },
              icon: Image.asset('lib/icons/home.png'),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => parkingList()),
                );
              },
              icon: Image.asset('lib/icons/searching.png'),
            ),
            IconButton(
              onPressed: () {},
              icon: Image.asset('lib/icons/credit.png'),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => profilePage()),
                );
              },
              icon: Image.asset('lib/icons/settings.png'),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // appbar

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      Container(
                        height: 50,
                        child: FittedBox(
                          child: Text(
                            'ParkALot Owner',
                            style: GoogleFonts.firaSans(
                                fontSize: 40,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 109, 139, 116)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(0, 100, 99, 99),
                      shape: BoxShape.circle,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      },
                      child: Icon(
                        Icons.notifications,
                        color: Color.fromARGB(255, 100, 100, 100),
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 10,
            ),

            Flexible(
              child: MapLocationPicker(
                apiKey: "AIzaSyBJkTw_pgCIMasJPW1FeG3cFfblLyPZ93A",
                onNext: (GeocodingResult? result) {},
              ),
            ),

            SizedBox(
              height: 10,
            ),

            Flexible(
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                myLocationButtonEnabled: true,
                compassEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 11.0,
                ),
                markers: Set<Marker>.of(_markers),
                onLongPress: _addMarker,
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  //Car
                  Container(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => navigationPage()),
                        );
                      },
                      child: MyButton(
                        iconImagePath: 'lib/icons/parkingAdd.png',
                      ),
                    ),
                  ),
                  // EV
                  Container(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => navigationPage()),
                        );
                      },
                      child: MyButton(
                        iconImagePath: 'lib/icons/evAdd.png',
                      ),
                    ),
                  )
                ],
              ),
            ),

            SizedBox(
              height: 1,
            ),
          ],
        ),
      ),
    );
  }

  void _addMarker(LatLng pos) {
    if (_origin == null || (_origin != null && _destination != null)) {
      setState(
        () {
          _origin = Marker(
            markerId: MarkerId('origin'),
            position: pos,
            infoWindow: InfoWindow(title: 'Origin'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
          );
          _destination = null as Marker;
        },
      );
    } else {
      setState(
        () {
          _destination = Marker(
            markerId: MarkerId('destination'),
            position: pos,
            infoWindow: InfoWindow(title: 'Destination'),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          );
        },
      );
    }
  }
}
