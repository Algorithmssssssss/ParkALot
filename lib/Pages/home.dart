// ignore_for_file: prefer_const_constructors, unnecessary_new
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:park_alot/Pages/maps.dart';
import 'package:park_alot/Pages/notification.dart';
import 'package:park_alot/Pages/profile.dart';
import 'package:park_alot/Pages/search.dart';
import 'package:park_alot/util/my_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_page.dart';
import 'ownerPages/gmaps_function.dart';
import 'ownerPages/owner_home.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser;

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
            onPressed: () {},
            icon: Image.asset('lib/icons/home.png'),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => navigationPage()),
              );
            },
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
                              'ParkALot',
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
                              builder: (context) => ownerHomePage()),
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

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(),
            ),

            SizedBox(
              height: 1,
            ),

            Flexible(
              child: gmaps_container(),
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
                        iconImagePath: 'lib/icons/parking-area.png',
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
                        iconImagePath: 'lib/icons/electric-car.png',
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
