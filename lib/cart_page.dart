import 'package:flutter/material.dart';
import 'package:tp_clothing/buy_page.dart';

// This will be a global cart list to manage the cart items
List<Map<String, dynamic>> cartItems = [];

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    double total = cartItems.fold(0, (sum, item) => sum + item['price']);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
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
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Image.network(item['image_url'], width: 50, height: 50, fit: BoxFit.cover),
                      title: Text(item['title']),
                      subtitle: Text('Size: ${item['size']} \nPrice: \$${item['price'].toStringAsFixed(2)}'),
                      trailing: IconButton(
                        icon: Icon(Icons.close, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            cartItems.removeAt(index); // Remove item from cart
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            Divider(),
            Text(
              'Total: \$${total.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Checkout logic can go here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text('Checkout', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
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
        currentIndex: 1, // Set to Cart as the default selected tab
        selectedItemColor: Color.fromARGB(255, 54, 155, 244), // Cart is active
        onTap: (index) {
          if (index == 0) {
            // Navigate to BuyPage
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BuyPage()),
            );
          } else if (index == 1) {
            // Navigate to CartPage
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CartPage()),
            );
          }
        },
      ),
    );
  }
}