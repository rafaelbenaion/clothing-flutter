import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddClothingPage extends StatefulWidget {
  @override
  _AddClothingPageState createState() => _AddClothingPageState();
}

class _AddClothingPageState extends State<AddClothingPage> {
  File? _image;
  final _picker = ImagePicker();
  String? _imageUrl;  // URL after upload to Firebase Storage
  String? _selectedCategory;  // Category dropdown selection
  String? _selectedSize;  // Size dropdown selection

  TextEditingController _titleController = TextEditingController();
  TextEditingController _brandController = TextEditingController();
  TextEditingController _priceController = TextEditingController();

  // Available options for the dropdown menus
  final List<String> _categories = ['Pants', 'T-shirt', 'Shoes'];
  final List<String> _sizes = ['S', 'M', 'L', 'XL', 'XXL'];

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_image != null) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef = FirebaseStorage.instance.ref().child('clothing_images/$fileName');

      UploadTask uploadTask = storageRef.putFile(_image!);
      TaskSnapshot snapshot = await uploadTask.whenComplete(() => {});
      _imageUrl = await snapshot.ref.getDownloadURL();
    }
  }

  Future<void> _saveClothing() async {
    if (_titleController.text.isEmpty || _brandController.text.isEmpty || _priceController.text.isEmpty || _imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill in all fields and upload an image.')));
      return;
    }

    // Save clothing data to Firestore
    await FirebaseFirestore.instance.collection('clothes').add({
      'title': _titleController.text,
      'brand': _brandController.text,
      'price': double.parse(_priceController.text),
      'size': _selectedSize,
      'category': _selectedCategory,
      'image_url': _imageUrl,
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Clothing added successfully!')));
    Navigator.pop(context);  // Navigate back after saving
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Clothing'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image Picker and Display
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: _image != null
                      ? Image.file(_image!, fit: BoxFit.cover)
                      : Icon(Icons.add_photo_alternate, size: 100, color: Colors.grey[700]),
                ),
              ),
              SizedBox(height: 16),

              // Title TextField
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              SizedBox(height: 16),

              // Category Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Category'),
                value: _selectedCategory,
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
              SizedBox(height: 16),

              // Size Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Size'),
                value: _selectedSize,
                items: _sizes.map((String size) {
                  return DropdownMenuItem<String>(
                    value: size,
                    child: Text(size),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSize = value;
                  });
                },
              ),
              SizedBox(height: 16),

              // Brand TextField
              TextField(
                controller: _brandController,
                decoration: InputDecoration(labelText: 'Brand'),
              ),
              SizedBox(height: 16),

              // Price TextField (numeric only)
              TextField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Price'),
              ),
              SizedBox(height: 32),

              // Save Button
              ElevatedButton(
                onPressed: () async {
                  await _uploadImage();  // Upload image first
                  _saveClothing();       // Save clothing data
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text('Save Clothing', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}