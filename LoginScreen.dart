import 'package:XPID/Login_screens/RegisterScreen.dart';
import 'package:XPID/Login_screens/auth_service.dart';
import 'package:XPID/components/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:XPID/screens/HomeScreen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  final Function(bool success) onLogin; // Updated to accept a boolean parameter
  LoginScreen({Key? key, required this.onLogin}) : super(key: key);
  //
  //LoginScreen({Key? key, this.onLogin}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late AuthService _authService; // Instance of AuthService

  @override
  void initState() {
    super.initState();
    _authService = AuthService(); // Initialize AuthService instance
  }

  //User Sign in - EMAIL - Google - Apple
  void signInWithEmailPassword() async {
    print('Sign In with email button tapped');
    // Show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Color(0xFFF37037)),
          ),
        );
      },
    );
    // Sign User in with Email and Password
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // Notify the parent (AuthPage) that login was successful
      print('Login successful');
      // Navigate to HomeScreen after successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Exception: $e');
      // Show error message
      showErrorMessage(e.code);
      // Notify the parent (AuthPage) that login failed
      widget.onLogin(false);
    }
  }

  void signInWithGoogle() async {
    print('Google Sign in tapped');
    // Show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Color(0xFFF37037)),
          ),
        );
      },
    );
    // Sign User in with Google
    try {
      bool googleSignInSuccess = await _authService.signInWithGoogle();
      if (googleSignInSuccess) {
        // Navigate to HomeScreen after successful Google sign-in
        print('Google sign-in successful');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
        print('After Google Signin navigation');
      } else {
        // Notify the user that sign-in failed
        showErrorMessage('Google sign-in failed');
      }
    } catch (e) {
      print('Error signing in with Google: $e');
      // Notify the user that sign-in failed
      showErrorMessage('Google sign-in failed');
    }
  }

  void signInWithApple() async {
    print('Apple Sign in tapped');
    // Show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Color(0xFFF37037)),
          ),
        );
      },
    );
    try {
      UserCredential? appleUserCredential =
          await AuthService().signInWithApple();
      if (appleUserCredential != null) {
        // Navigate to HomeScreen after successful Apple sign-in
        print('Apple sign-in successful');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      } else {
        // Notify the user that sign-in failed
        showErrorMessage('Apple sign-in failed');
      }
    } catch (e) {
      print('Error signing in with Apple: $e');
      // Notify the user that sign-in failed
      showErrorMessage('Apple sign-in failed');
    }
  }

  //Show login error message to user popup
  void showErrorMessage(String message) {
    showDialog(
      context: context,
      //context: scaffoldKey.currentContext!,
      builder: (context) {
        return AlertDialog(
            backgroundColor: Color(0xFFF37037),
            title: Center(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ));
      },
    );
  }

  // Dispose method to release resources
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Building LoginScreen');
    return Scaffold(
        key: scaffoldKey,
        body: SafeArea(
            child: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              stops: [0.02, 0.08, 0.17, 0.35],
              colors: [
                Color(0xFFEE2E3B),
                Color(0xFFF89E2C),
                Color(0xFFF89E2C).withOpacity(0.50),
                Color(0xFFFFFFFF),
              ],
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  Image.asset('assets/Transparent_2.png', height: 70),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Welcome to XPID!',
                    style: TextStyle(fontSize: 24, color: Colors.black),
                  ),
                  SizedBox(height: 20),
                  // Sign in with Google and Apple
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: GestureDetector(
                      onTap: () async {
                        //Call the relevant method from AuthService
                        await AuthService().signInWithGoogle();
                        widget.onLogin(true);
                      },
                      child: Image.asset('assets/GoogleLogin.png'),
                    ),
                  ),

                  SizedBox(height: 10),
                  // Continue with Apple Account
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: GestureDetector(
                      onTap: () async {
                        //Call the relevant method from AuthService
                        await AuthService().signInWithApple();
                        widget.onLogin(true);
                      },
                      child: Image.asset('assets/AppleLogin.png'),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'OR',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  // Enter Email
                  CustomTextField(
                    controller: emailController,
                    hintText: 'Enter your email',
                  ),

                  SizedBox(height: 5),
                  // Enter Password
                  CustomTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),
                  SizedBox(height: 5),
                  // Forgot Password?
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('Forgot Password?',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[600])),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  // Submit Email button
                  // Submit Email button
                  GestureDetector(
                    onTap: () {
                      signInWithEmailPassword();
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.symmetric(horizontal: 25),
                      decoration: BoxDecoration(
                        color: Color(0xFFF37037),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(fontSize: 12, color: Colors.grey[800]),
                      ),
                      SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          // Navigate to the RegisterScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterScreen()),
                          );
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      )
                    ],
                  )
                  // Terms and Conditions
                ],
              ),
            ),
          ),
        )));
  }
}
