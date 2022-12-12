// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_final_fields, unused_field, unnecessary_new, unused_local_variable
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// pages imports
import 'package:park_alot/Pages/home.dart';
import 'package:park_alot/Pages/ownerPages/add_locations.dart';
import 'package:park_alot/Pages/profile.dart';
import 'package:park_alot/Pages/search.dart';
import '../../util/my_button.dart';
import 'gmaps_function.dart';
import 'owner_list.dart';

class ownerHomePage extends StatefulWidget {
  const ownerHomePage({Key? key}) : super(key: key);

  @override
  State<ownerHomePage> createState() => _ownerHomePageState();
}

class _ownerHomePageState extends State<ownerHomePage> {
  final user = FirebaseAuth.instance.currentUser;

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
                      onTap: () {},
                      child: MyButton(
                        iconImagePath: 'lib/icons/parkingAdd.png',
                      ),
                    ),
                  ),
                  // EV
                  Container(
                    child: GestureDetector(
                      onTap: () {},
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
