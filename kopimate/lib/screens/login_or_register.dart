import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  //initally show login page
  bool showLogin = true;

  //toogle between login and register
  void togglePages() {
    setState(() {
      showLogin = !showLogin;
    });
  }
  @override
  Widget build(BuildContext context) {
    if (showLogin) {
      return Login(
        onTap: togglePages,
      );
    } else {
      return Register(
        onTap: togglePages,
      );
    }
  }
}