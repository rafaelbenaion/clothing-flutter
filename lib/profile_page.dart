// --------------------------------------------------------------------------------------------- //
// Project Mobile, M2 MIAGE IAE, Université Côte d'Azur                                          //
// --------------------------------------------------------------------------------------------- //
// Description:                                                                                  //
// This project is a mockup Flutter clone of the Vintage app using Firebase.                     //
// --------------------------------------------------------------------------------------------- //
// Rafael Baptista, 2024                                                                         //
// --------------------------------------------------------------------------------------------- //

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';  // Import to format the date
import 'cart_page.dart';
import 'buy_page.dart';
import 'add_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _birthDateController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _postalCodeController = TextEditingController();
  TextEditingController _cityController = TextEditingController();

  int _selectedIndex = 2; // Set ProfilePage as the default active tab

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    _user = _auth.currentUser;

    if (_user != null) {
      // Fetch user data from Firestore
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(_user!.uid).get();

      if (userDoc.exists) {
        var data = userDoc.data() as Map<String, dynamic>;
        setState(() {
          _emailController.text = _user!.email ?? '';
          _passwordController.text = '********';  // Hidden password
          _birthDateController.text = data['birthDate'] ?? '';
          _addressController.text = data['address'] ?? '';
          _postalCodeController.text = data['postalCode'] ?? '';
          _cityController.text = data['city'] ?? '';
        });
      }
    }
  }

  Future<void> _saveProfileData() async {
    if (_user != null) {
      await _firestore.collection('users').doc(_user!.uid).update({
        'birthDate': _birthDateController.text,
        'address': _addressController.text,
        'postalCode': _postalCodeController.text,
        'city': _cityController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );
    }
  }

  Future<void> _logout() async {
    await _auth.signOut();
    setState(() {
      cartItems.clear();  // Empty the cart
    });
    Navigator.pushReplacementNamed(context, '/login');  // Navigate back to login
  }

  // Function to show the date picker
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),  // Set the initial date to today
      firstDate: DateTime(1900),    // Set the earliest date the user can pick
      lastDate: DateTime.now(),     // Set the latest date to today
    );

    if (pickedDate != null) {
      // Format the selected date to "DD/MM/YYYY"
      String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);

      setState(() {
        // Update the TextEditingController with the formatted date
        _birthDateController.text = formattedDate;
      });
    }
  }

  // BottomNavigationBar onTap handler
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BuyPage()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CartPage()),
      );
    } else if (index == 2) {
      // Already on ProfilePage, do nothing
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Email (read-only)
            TextField(
              controller: _emailController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Login (Email)',
              ),
            ),
            SizedBox(height: 16),
            
            // Password (hidden)
            TextField(
              controller: _passwordController,
              obscureText: true,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 16),

            // Birth Date (using DatePicker)
            GestureDetector(
              onTap: () {
                _selectDate(context);  // Call the date picker when tapped
              },
              child: AbsorbPointer(
                child: TextField(
                  controller: _birthDateController,
                  decoration: InputDecoration(
                    labelText: 'Birth Date',
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            
            // Address
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Address',
              ),
            ),
            SizedBox(height: 16),
            
            // Postal Code (numeric only)
            TextField(
              controller: _postalCodeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Postal Code',
              ),
            ),
            SizedBox(height: 16),
            
            // City
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: 'City',
              ),
            ),
            SizedBox(height: 32),
            
            // Save Button
            ElevatedButton(
              onPressed: _saveProfileData,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 127, 181, 127),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text('Save', style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 16),
            
            // Add Clothing Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddClothingPage()),  // Navigate to the AddClothingPage
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 0, 0, 0),  // Black background
                padding: EdgeInsets.symmetric(vertical: 16),  // Padding for height
              ),
              child: Text('Add a Clothing', style: TextStyle(color: Colors.white)),  // White text
            ),
            SizedBox(height: 16),
            
            // Logout Button
            ElevatedButton(
              onPressed: _logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text('Logout', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
      // Add the BottomNavigationBar here
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