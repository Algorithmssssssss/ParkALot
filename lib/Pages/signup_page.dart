// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:park_alot/signupdb.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const RegisterPage({
    Key? key,
    required this.showLoginPage,
  }) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final user = FirebaseAuth.instance.currentUser;
  final _form = GlobalKey<FormState>();
  // text controller
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordCheckController = TextEditingController();
  final _phoneCheckController = TextEditingController();
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref().child('users');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneCheckController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future signUp() async {
    if (passwordConfirmed()) {
      // create user
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // add user details
      addUserDetials(
        _usernameController.text.trim(),
        _emailController.text.trim(),
        _phoneCheckController.text.trim(),
      );

      // add user to rtdb
      addUserRtdb();
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('Password is not the same!'),
            );
          });
    }
  }

  Future addUserDetials(
      String username, String email, String phonenumber) async {
    print('Username:');
    print(email);
    // "123"
    await FirebaseFirestore.instance.collection('users').doc(email).set({
      'username': username,
      'email': email,
      'phonenumber': phonenumber,
    });
  }

  //addUserRtdb
  addUserRtdb() {
    ref.push().child('test').set({
      'username': _usernameController.text.trim(),
    });
  }

  bool passwordConfirmed() {
    if (_passwordCheckController.text.trim() ==
        _passwordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  void writeData() async {
    _form.currentState?.save();

    // Please replace the Database URL
    // which we will get in “Add Realtime
    // Database” step with DatabaseURL
    var url =
        "https://park-a-lot-25cdb-default-rtdb.europe-west1.firebasedatabase.app/" +
            "names.json";

    // (Do not remove “data.json”,keep it as it is)

    final response = await http.post(
      Uri.parse(url),
      body: json.encode({"users": "test"}),
    );
  }

  void addrtdb(rtdb RTDB) {
    ref.push().set(RTDB.toJson());
  }

  @override
  Widget build(BuildContext context) {
    print(ref.key);
    ref.push().set({
      'users': "Test",
    }).asStream();
    addrtdb;
    addUserRtdb();
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 198, 220, 228),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(
                Icons.local_parking,
                size: 70,
              ),
              SizedBox(
                height: 15,
              ),

              // Hello text
              Text(
                'Hello There!',
                style: GoogleFonts.bebasNeue(
                  fontSize: 45,
                ),
              ),

              SizedBox(
                height: 10,
              ),

              Text(
                'Register with your details to join ParkALot',
                style: TextStyle(
                  fontSize: 17,
                ),
              ),

              SizedBox(
                height: 30,
              ),

              //username

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightBlueAccent),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Username',
                    fillColor: Colors.grey[200],
                    filled: true,
                  ),
                ),
              ),

              SizedBox(
                height: 20,
              ),

              //email

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightBlueAccent),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Email',
                    fillColor: Colors.grey[200],
                    filled: true,
                  ),
                ),
              ),

              SizedBox(
                height: 20,
              ),

              //phone number
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  controller: _phoneCheckController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightBlueAccent),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Phone Number',
                    fillColor: Colors.grey[200],
                    filled: true,
                  ),
                ),
              ),

              SizedBox(
                height: 20,
              ),

              //password
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  obscureText: true,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightBlueAccent),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Password',
                    fillColor: Colors.grey[200],
                    filled: true,
                  ),
                ),
              ),

              SizedBox(
                height: 20,
              ),

              //password Check
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  obscureText: true,
                  controller: _passwordCheckController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightBlueAccent),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Repeat Password',
                    fillColor: Colors.grey[200],
                    filled: true,
                  ),
                ),
              ),

              SizedBox(
                height: 20,
              ),

              //signup Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: GestureDetector(
                  onTap: signUp,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(12)),
                    child: Center(
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 25,
              ),

              //Registry Button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'I have signed up!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.showLoginPage,
                    child: Text(
                      ' Login now',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),

              SizedBox(
                height: 25,
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
