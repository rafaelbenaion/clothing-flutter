import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'detail_page.dart';
import 'cart_page.dart';
import 'profile_page.dart';

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
        automaticallyImplyLeading: false,
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

              // Alternate background colors
              Color backgroundColor = index % 2 == 0 ? Colors.white : Colors.grey[200]!;

              return GestureDetector(
                onTap: () {
                  // Navigate to the detail page when a clothing item is tapped
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(clothing: clothing),  // Pass clothing data to DetailPage
                    ),
                  );
                },
                child: Container(
                  color: backgroundColor,
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),  // Add padding around the image
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: NetworkImage(clothing['image_url']),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                clothing['title'],
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4),
                              // Ensure price always has two decimal places
                              Text('Taille: ${clothing['size']} - Prix: ${clothing['price'].toStringAsFixed(2)} €'),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),  // Add padding to the right of the arrow
                        child: Icon(Icons.arrow_forward_ios, color: Colors.black),
                      ),
                    ],
                  ),
                ),
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
        selectedItemColor: const Color.fromARGB(255, 0, 0, 0), // Active tab color will be blue
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