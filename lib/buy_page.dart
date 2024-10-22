// --------------------------------------------------------------------------------------------- //
// Project Mobile, M2 MIAGE IAE, Université Côte d'Azur                                          //
// --------------------------------------------------------------------------------------------- //
// Description:                                                                                  //
// This project is a light Flutter clone of the Vintage app using Firebase.                      //
// --------------------------------------------------------------------------------------------- //
// Rafael Baptista, 2024                                                                         //
// --------------------------------------------------------------------------------------------- //

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BuyPage extends StatefulWidget {
  @override
  _BuyPageState createState() => _BuyPageState();
}

class _BuyPageState extends State<BuyPage> {
  int _selectedIndex = 0;

  final List<String> _pageTitles = ['Acheter', 'Panier', 'Profil'];

  // This function will handle what happens when you click on a bottom nav item
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // You can add navigation or different logic here when switching tabs
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des vêtements à acheter'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('clothing').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final clothes = snapshot.data?.docs ?? [];

          return ListView.builder(
            itemCount: clothes.length,
            itemBuilder: (context, index) {
              final clothing = clothes[index].data() as Map<String, dynamic>;
              return ListTile(
                leading: Image.network(clothing['image_url']),
                title: Text(clothing['title']),
                subtitle: Text('Taille: ${clothing['size']} - Prix: ${clothing['price']} €'),
                onTap: () {
                  // We'll add navigation to the detail page later
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Acheter',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Panier',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}