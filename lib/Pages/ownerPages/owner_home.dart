// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_final_fields, unused_field, unnecessary_new, unused_local_variable
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_fonts/google_fonts.dart';
// pages imports
import 'package:park_alot/Pages/home.dart';
import 'package:park_alot/Pages/maps.dart';
import 'package:park_alot/Pages/ownerPages/add_locations.dart';
import 'package:park_alot/Pages/profile.dart';
import 'package:park_alot/Pages/search.dart';
import '../../util/my_button.dart';
import '../gmap_test.dart';
import '../notification.dart';
import 'get_parking_data.dart';
import 'get_placeid.dart';
import 'owner_list.dart';

// maps imports
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_location_picker/map_location_picker.dart';

// ESP32 imports
import 'package:wifi_iot/wifi_iot.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class ownerHomePage extends StatefulWidget {
  const ownerHomePage({Key? key}) : super(key: key);

  @override
  State<ownerHomePage> createState() => _ownerHomePageState();
}

class _ownerHomePageState extends State<ownerHomePage> {
  final user = FirebaseAuth.instance.currentUser;

  late GoogleMapController mapController;

  final List<Marker> _markers = <Marker>[];

  final LatLng _center = const LatLng(54.8985, 23.9036);

  late String userAgent;
  late http.Client _inner;
  String url = 'http://192.168.0.58:80/api';

  // Set up the POST body
  Map<String, String> body = {
    'name': 'doodle',
    'color': 'blue',
  };

  Future<void> adddata() async {
    await FirebaseFirestore.instance.collection('parkings').get().then(
          // ignore: avoid_function_literals_in_foreach_calls
          (snapshot) => snapshot.docs.forEach(
            (document) {
              var gmaps_id = document.data()['gmaps_id'];
              var maps_name = document.data()['name'];
              Map<String, String> body = {
                'name': document.data()['name'],
                'color': document.data()['gmaps_id'],
              };
              try {
                Dio()
                    .post('http://192.168.0.58:80/', data: body)
                    .then((response) {
                  print(response);
                });
              } catch (e) {
                print(e);
              }
            },
          ),
        );
  }

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

  void getHttp() async {
    try {
      var response = await Dio().get('http://192.168.0.58:80/');
      print(response);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _postdata() async {
    try {
      await Dio().post('http://192.168.0.58:80/', data: body).then((response) {
        print(response);
      });
    } catch (e) {
      print(e);
    }
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
              child: FutureBuilder(
                future: _getLocationData(),
                builder: (context, snapshot) {
                  return Container(
                    height: 500,
                    width: 500,
                    child: GoogleMap(
                      markers: Set<Marker>.of(_markers),
                      onMapCreated: _onMapCreated,
                      myLocationButtonEnabled: true,
                      myLocationEnabled: true,
                      compassEnabled: true,
                      initialCameraPosition: CameraPosition(
                        target: _center,
                        zoom: 11.0,
                      ),
                    ),
                  );
                },
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
                        adddata();
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
                        _getLocationData();
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
}
