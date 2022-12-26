import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class gmaps_container extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;
  CollectionReference usersDatabase =
      FirebaseFirestore.instance.collection('users');

  late GoogleMapController mapController;

  final List<Marker> _markers = <Marker>[];
  List<String> docIDs = [];

  final LatLng _center = const LatLng(54.8985, 23.9036);
  int mapType = 0;

  late String userAgent;
  late http.Client _inner;
  String url = 'http://192.168.0.58:80/api';

  // Set up the POST body
  Map<String, String> body = {
    'name': 'doodle',
    'color': 'blue',
  };

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  void sendPost(namePlace) async {
    String username = '';
    await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: user?.email)
        .get()
        .then(
          // ignore: avoid_function_literals_in_foreach_calls
          (snapshot) => snapshot.docs.forEach(
            (document) {
              print(user?.uid.toString());
              print(document.reference);
              print(document.data()['username']);
              username = document.data()['username'];

              docIDs.add(username);
            },
          ),
        );
    Map<String, String> body = {
      'name': '$namePlace',
      'user': username,
    };
    try {
      Dio().post('http://192.168.147.199:80/', data: body).then((response) {
        print(response);
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> getDocID() async {
    String names = '';
    await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: user?.email)
        .get()
        .then(
          // ignore: avoid_function_literals_in_foreach_calls
          (snapshot) => snapshot.docs.forEach(
            (document) {
              print(user?.uid.toString());
              print(document.reference);
              print(document.data()['name']);
              names = document.data()['name'];

              docIDs.add(names);
            },
          ),
        );
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
          onTap: () {
            sendPost(placeNameLists[i]);
            print(placeNameLists[i]);
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getLocationData(),
      builder: (context, snapshot) {
        return SizedBox(
          child: GoogleMap(
            markers: Set<Marker>.of(_markers),
            onMapCreated: _onMapCreated,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            trafficEnabled: true,
            compassEnabled: true,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
          ),
        );
      },
    );
  }
}
