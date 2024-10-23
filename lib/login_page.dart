// --------------------------------------------------------------------------------------------- //
// Project Mobile, M2 MIAGE IAE, Université Côte d'Azur                                          //
// --------------------------------------------------------------------------------------------- //
// Description:                                                                                  //
// This project is a light Flutter clone of the Vintage app using Firebase.                      //
// --------------------------------------------------------------------------------------------- //
// Rafael Baptista, 2024                                                                         //
// --------------------------------------------------------------------------------------------- //

import 'package:tp_clothing/home_page.dart';
import 'package:tp_clothing/buy_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _errorMessage = '';

  Future<void> _login() async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    );
    // Navigate to the next page or show success
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BuyPage()), // Define HomePage
    );
  } on FirebaseAuthException catch (e) {
    setState(() {
      _errorMessage = e.message ?? 'An error occurred.';
    });
    print('Error: ${e.message}');  // Debugging the exact error
  } catch (e) {
    print('Unknown error: $e');
    setState(() {
      _errorMessage = 'Network error occurred. Please try again.';
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Clothing App'),
        automaticallyImplyLeading: false,  // This hides the back button
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Login',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true, // Hide the password
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _login,
              child: Text('Se connecter'),
            ),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}

