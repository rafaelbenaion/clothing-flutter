import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tp_clothing/detail_page.dart';
import 'package:tp_clothing/cart_page.dart';
import 'package:tp_clothing/profile_page.dart';

class BuyPage extends StatefulWidget {
  @override
  _BuyPageState createState() => _BuyPageState();
}

class _BuyPageState extends State<BuyPage> {
  int _selectedIndex = 0;

  final List<String> _pageTitles = ['Acheter', 'Panier', 'Profil'];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clothing App'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('clothes').snapshots(),
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
                leading: Image.network(clothing['image_url']),  // Display the image using the URL
                title: Text(clothing['title']),
                subtitle: Text('Taille: ${clothing['size']} - Prix: ${clothing['price']} €'),
                onTap: () {
                  // Navigate to the detail page when a clothing item is tapped
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(clothing: clothing),  // Pass clothing data to DetailPage
                    ),
                  );
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
            label: 'Buy',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'My Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex, // Active tab index
        selectedItemColor: const Color.fromARGB(255, 112, 191, 255), // Active tab color will be blue
        onTap: (index) {
          setState(() {
            _selectedIndex = index;  // Update the current index
          });

          // Navigation logic based on the selected index
          if (_selectedIndex == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => BuyPage()),
            );
          } else if (_selectedIndex == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => CartPage()),
            );
          } else if (_selectedIndex == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          }
        },
      ),
    );
  }
}