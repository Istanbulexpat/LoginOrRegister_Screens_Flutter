import 'package:XPID/Login_screens/LoginScreen.dart';
import 'package:XPID/Login_screens/RegisterScreen.dart';
import 'package:flutter/material.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({
    Key? key,
    required this.onLogin,
  }) : super(key: key);

  final void Function(bool success) onLogin;

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  // initially show Login page
  bool showLoginPage = true;

// Method to toggle between login and register pages
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  // Method to handle login success or failure
  void handleLogin(bool success) {
    if (success) {
      // If login is successful, do not toggle to the RegisterScreen
      // You may also handle navigation to the HomeScreen here if needed
      // For this example, we simply notify the parent widget via onLogin
      widget.onLogin(true);
    } else {
      // If login fails, toggle to the RegisterScreen
      togglePages();
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Building LoginorRegister');
    if (showLoginPage) {
      return LoginScreen(
        onLogin: handleLogin, // Pass the handleLogin method to LoginScreen
      );
    } else {
      return RegisterScreen(
        onLogin: handleLogin, // Similarly, pass handleLogin to RegisterScreen
      );
    }
  }
}
