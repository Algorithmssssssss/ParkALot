// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_final_fields, unused_field, unnecessary_new

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:park_alot/Pages/home.dart';
import 'package:park_alot/Pages/ownerPages/owner_home.dart';
import 'package:park_alot/Pages/profile.dart';
import 'package:park_alot/Pages/search.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:map_location_picker/map_location_picker.dart';
import 'package:location/location.dart';

import '../util/my_button.dart';
import 'login_page.dart';
import 'notification.dart';

class navigationPage extends StatefulWidget {
  const navigationPage({Key? key}) : super(key: key);

  @override
  State<navigationPage> createState() => _navigationPageState();
}

class _navigationPageState extends State<navigationPage> {
  final user = FirebaseAuth.instance.currentUser;
  final List<Marker> _markers = <Marker>[];
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(54.8985, 23.9036);

  void _onMapCreated(GoogleMapController controller) async {
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

  Future<void> _getLocationData() async {
    List<String> placeidLists = [];
    List<String> placeNameLists = [];
    List placeList = [];
    await FirebaseFirestore.instance.collection('parkings').get().then(
          // ignore: avoid_function_literals_in_foreach_calls
          (snapshot) => snapshot.docs.forEach(
            (document) {
              var gmaps_id = document.data()['gmaps_id'];
              var maps_name = document.data()['name'];
              print(gmaps_id);
              placeidLists.add(gmaps_id);
              placeNameLists.add(maps_name);
              print(placeidLists);
            },
          ),
        );
    for (var i = 0; i < placeidLists.length; i++) {
      List<geo.Location> markerlocations =
          await geo.locationFromAddress(placeidLists[i]);
      print(markerlocations);
      placeList.add(markerlocations);
    }
    for (var i = 0; i < placeList.length; i++) {
      _markers.add(
        Marker(
          markerId: MarkerId(i.toString()),
          position: LatLng(placeList[i][0].latitude, placeList[i][0].longitude),
          infoWindow: InfoWindow(title: placeNameLists[i]),
        ),
      );
    }
  }

  @override
  void initState() {
    getUserCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 198, 220, 228),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => searchPage()),
          );
        },
        backgroundColor: Color.fromARGB(255, 109, 139, 116),
        child: Icon(Icons.search),
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
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              icon: Image.asset('lib/icons/home.png'),
            ),
            IconButton(
              onPressed: () {},
              icon: Image.asset('lib/icons/navigator.png'),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ownerHomePage()),
                );
              },
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
          children: [
            // appbar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Row(
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      Container(
                        height: 50,
                        child: FittedBox(
                          child: Text(
                            'Navigation',
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
                          MaterialPageRoute(
                              builder: (context) => notificationPage()),
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
              height: 1,
            ),
            Flexible(
              child: FutureBuilder(
                future: _getLocationData(),
                builder: (context, snapshot) {
                  return Container(
                    child: GoogleMap(
                        markers: Set<Marker>.of(_markers),
                        onMapCreated: _onMapCreated,
                        myLocationButtonEnabled: true,
                        compassEnabled: true,
                        myLocationEnabled: true,
                        initialCameraPosition: CameraPosition(
                          target: _center,
                          zoom: 11.0,
                        )),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
