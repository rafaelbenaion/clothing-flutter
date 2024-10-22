import 'package:flutter/material.dart';
import 'cart_page.dart';  // Import the Cart Page

class DetailPage extends StatelessWidget {
  final Map<String, dynamic> clothing;

  DetailPage({required this.clothing});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 234, 232, 232),  // Set the background color to a light grey
      appBar: AppBar(
        title: Text(clothing['title']),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to BuyPage
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image container to ensure square dimensions and central alignment
            GestureDetector(
              onTap: () {
                // Show full image in a pop-up when the image is tapped
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.network(clothing['image_url']),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                            },
                            child: Text('Fermer'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Container(
                height: 300,  // Define the height of the square
                width: double.infinity,   // Full width
                decoration: BoxDecoration(
                  color: Colors.grey[200], // Placeholder background
                  borderRadius: BorderRadius.circular(8),
                ),
                clipBehavior: Clip.hardEdge,
                child: Image.network(
                  clothing['image_url'],
                  fit: BoxFit.cover, // Ensure the image fills the square and crops if necessary
                ),
              ),
            ),
            SizedBox(height: 20),
            
            // Title and Price Section
            Text(
              clothing['title'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),  // Bold title
            ),
            SizedBox(height: 8),
            Text(
              '\$${clothing['price'].toStringAsFixed(2)}',
              style: TextStyle(fontSize: 22 , color: Colors.black),
            ),
          
            
            SizedBox(height: 16),
            
            // Brand and Category
            Text('Category: ${clothing['category']}', style: TextStyle(color: Colors.black)),
            SizedBox(height: 8),
            Text('Brand: ${clothing['brand']}', style: TextStyle(color: Colors.black)),

            // Size selection
            SizedBox(height: 8),
            Text('Size:', style: TextStyle(color: Colors.black)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildFakeSizeButton('S', clothing['size']),
                _buildFakeSizeButton('M', clothing['size']),
                _buildFakeSizeButton('L', clothing['size']),
                _buildFakeSizeButton('XL', clothing['size']),
                _buildFakeSizeButton('XXL', clothing['size']),
              ],
            ),
            Spacer(),
            
            
            // Add to Cart Button
            ElevatedButton(
              onPressed: () {
                // Add the current item to the cart
                cartItems.add(clothing);
                
                // Redirect to the CartPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black, // Button color
                padding: EdgeInsets.symmetric(vertical: 16), // Button height
              ),
              child: Text('Add to Cart', style: TextStyle(color: Colors.white)),  // White text on black button
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to create fake size buttons
  Widget _buildFakeSizeButton(String size, String selectedSize) {
    bool isSelected = size == selectedSize;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            size,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}