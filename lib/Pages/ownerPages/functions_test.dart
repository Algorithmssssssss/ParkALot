import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';

final user = FirebaseAuth.instance.currentUser;

Future<void> _testingfunction(marker) async {
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
    marker.add(
      Marker(
        markerId: MarkerId(i.toString()),
        position: LatLng(placeList[i][0].latitude, placeList[i][0].longitude),
        infoWindow: InfoWindow(title: placeNameLists[i]),
      ),
    );
  }
}

void sendPost(namePlace) async {
  Map<String, String> body = {
    'name': '$namePlace',
    'user': '${user!.email}',
  };
  try {
    Dio().post('http://192.168.0.58:80/', data: body).then((response) {
      print(response);
    });
  } catch (e) {
    print(e);
  }
}
