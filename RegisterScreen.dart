import 'package:XPID/components/textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:XPID/Login_screens/auth_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:XPID/Login_screens/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  final Function(bool success)? onLogin;
  RegisterScreen({Key? key, this.onLogin}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Method to add user data to Firestore
  Future<void> addUserToFirestore(String email) async {
    try {
      final userData = {
        'date_created': DateTime.now(),
        'email': email,
      };
      await FirebaseFirestore.instance
          .collection('users')
          .doc(email)
          .set(userData);
    } catch (e) {
      print('Error adding user data to Firestore: $e');
    }
  }

  //Sign user up method
  void signUserUp() async {
    print('Register button tapped');

    try {
      // Show loading circle
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            content: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Color(0xFFF37037)),
            ),
          );
        },
      );

      // Check if password is confirmed
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // After successful registration, add the user's email to Firestore
        await addUserToFirestore(emailController.text);
      } else {
        // Delay showing the error message for 2 seconds
        Future.delayed(const Duration(seconds: 2), () {
          // Dismiss the loading dialog
          Navigator.pop(context);
          // Show error message, passwords don't match
          showErrorMessage("Passwords don't match!");
        });
        return; // Return here to prevent further execution
      }

      // Dismiss the loading dialog
      Navigator.pop(context);
      // Notify the parent (AuthPage) that login was successful
      widget.onLogin?.call(true);
      // Pop the LoginScreen from the navigation stack
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Exception: $e');
      // Dismiss the loading dialog
      Navigator.pop(context);
      // Show error message
      showErrorMessage(e.code);
      // Notify the parent (AuthPage) that login failed
      widget.onLogin?.call(false);
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
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Building RegisterScreen');
    return Scaffold(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/Transparent_2.png', height: 70),
                  SizedBox(width: 10),
                  Text(
                    'Sign Up!',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF83191C)),
                  ),
                ],
              ),

              SizedBox(
                height: 10,
              ),

              SizedBox(height: 10),

              // Enter Email
              CustomTextField(
                controller: emailController,
                hintText: 'Enter your email',
              ),

              SizedBox(height: 5),
              // Enter Password
              CustomTextField(
                controller: passwordController,
                hintText: 'Enter a Password',
                obscureText: true,
              ),
              SizedBox(height: 5),
              // Forgot Password?
              CustomTextField(
                controller: confirmPasswordController,
                hintText: 'Confirm Password',
                obscureText: true,
              ),
              SizedBox(height: 10),
              // Submit Email button
              GestureDetector(
                onTap: signUserUp,
                child: Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                    color: Color(0xFFF37037),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'Register',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Or Continue With
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
              // Continue with Google Account
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: GestureDetector(
                  onTap: () async {
                    bool success = await AuthService().signInWithGoogle();
                    if (success) {
                      widget.onLogin?.call(true);
                    } else {
                      showErrorMessage('Google Sign-In failed');
                      widget.onLogin?.call(false);
                    }
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
                    UserCredential? userCredential =
                        await AuthService().signInWithApple();
                    if (userCredential != null) {
                      widget.onLogin?.call(true);
                    } else {
                      showErrorMessage('Apple Sign-In failed');
                      widget.onLogin?.call(false);
                    }
                  },
                  child: Image.asset('assets/AppleLogin.png'),
                ),
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(fontSize: 12, color: Colors.grey[800]),
                  ),
                  SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      // Navigate to RegisterScreen when "Sign Up" is tapped
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AuthPage()),
                      );
                    },
                    child: Text(
                      "Sign In!",
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
