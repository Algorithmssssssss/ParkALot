// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:park_alot/Pages/maps.dart';
import 'package:park_alot/Pages/profile.dart';

import 'home.dart';
import 'ownerPages/owner_home.dart';

class notificationPage extends StatefulWidget {
  const notificationPage({Key? key}) : super(key: key);

  @override
  State<notificationPage> createState() => _notificationPageState();
}

class _notificationPageState extends State<notificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 198, 220, 228),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
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
                              'Notification',
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
                      child: Icon(
                        Icons.notifications,
                        color: Color.fromARGB(255, 100, 100, 100),
                        size: 30,
                      )),
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
