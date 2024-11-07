// --------------------------------------------------------------------------------------------- //
// Project Mobile, M2 MIAGE IAE, Université Côte d'Azur                                          //
// --------------------------------------------------------------------------------------------- //
// Description:                                                                                  //
// This project is a mockup Flutter clone of the Vintage app using Firebase.                     //
// --------------------------------------------------------------------------------------------- //
// Rafael Baptista, 2024                                                                         //
// --------------------------------------------------------------------------------------------- //

import 'package:tp_clothing/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Text('List of available clothes :'),
      ),
    );
  }
}