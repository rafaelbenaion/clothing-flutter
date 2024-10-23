// --------------------------------------------------------------------------------------------- //
// Project Mobile, M2 MIAGE IAE, Université Côte d'Azur                                          //
// --------------------------------------------------------------------------------------------- //
// Description:                                                                                  //
// This project is a light Flutter clone of the Vintage app using Firebase.                      //
// --------------------------------------------------------------------------------------------- //
// Rafael Baptista, 2024                                                                         //
// --------------------------------------------------------------------------------------------- //

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tp_clothing/login_page.dart';
import 'package:tp_clothing/buy_page.dart';
import 'package:tp_clothing/cart_page.dart';
import 'package:tp_clothing/profile_page.dart';
import 'firebase_options.dart'; // Auto-generated file by FlutterFire CLI
import 'package:firebase_auth/firebase_auth.dart';

// --------------------------------------------------------------------------------------------- //
// Firebase initialization                                                                       //
// --------------------------------------------------------------------------------------------- //

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clothing App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: AuthGate(), // Use AuthGate as the starting page
      routes: {
        '/login': (context) => LoginPage(),
        '/buy': (context) => BuyPage(),
        '/cart': (context) => CartPage(),
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}

class AuthGate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while waiting for Firebase to check auth state
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          // User is logged in, show BuyPage
          return BuyPage();
        } else {
          // User is not logged in, show LoginPage
          return LoginPage();
        }
      },
    );
  }
}