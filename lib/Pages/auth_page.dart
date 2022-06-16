import 'package:flutter/material.dart';
import 'package:park_alot/Pages/login_page.dart';
import 'package:park_alot/Pages/signup_page.dart';

import 'owner_signup.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  // init, show the login page
  bool showLoginPage = true;
  bool showOwnerRegPage = true;

  void toggleScreens() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(
        showRegisterPage: toggleScreens,
      );
    } else {
      return RegisterPage(showLoginPage: toggleScreens);
    }
  }
}
