// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_final_fields, unused_field, unnecessary_new

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:park_alot/Pages/home.dart';
import 'package:park_alot/Pages/ownerPages/owner_home.dart';
import 'package:park_alot/Pages/profile.dart';
import 'package:park_alot/Pages/search.dart';

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
  List<Marker> markers = [];

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
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
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
        ]),
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
                          )),
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
              child: FlutterMap(
                options: MapOptions(
                  center: new LatLng(54.8985, 23.9036),
                  minZoom: 3.0,
                  boundsOptions: FitBoundsOptions(padding: EdgeInsets.all(1.0)),
                ),
                layers: [
                  new TileLayerOptions(
                    urlTemplate:
                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c'],
                  ),
                  MarkerLayerOptions(
                    markers: [
                      new Marker(
                          width: 45.0,
                          height: 45.0,
                          point: new LatLng(54.8985, 23.9036),
                          builder: (context) => new Container(
                                child: IconButton(
                                  icon: Icon(Icons.location_on),
                                  color: Colors.cyanAccent,
                                  iconSize: 45.0,
                                  onPressed: () {
                                    print('Marker tapped');
                                  },
                                ),
                              ))
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
