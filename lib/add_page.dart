// --------------------------------------------------------------------------------------------- //
// Project Mobile, M2 MIAGE IAE, Université Côte d'Azur                                          //
// --------------------------------------------------------------------------------------------- //
// Description:                                                                                  //
// This project is a mockup Flutter clone of the Vintage app using Firebase.                     //
// --------------------------------------------------------------------------------------------- //
// Rafael Baptista, 2024                                                                         //
// --------------------------------------------------------------------------------------------- //

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart'; // For text input formatting
import 'onnx_service.dart';  // Import the OnnxService class
import 'dart:ui' as ui; // Ensure to import for image processing
import 'package:image/image.dart' as img; // Add this import

class AddClothingPage extends StatefulWidget {
  @override
  _AddClothingPageState createState() => _AddClothingPageState();
}

class _AddClothingPageState extends State<AddClothingPage> {
  File? _image;
  final _picker = ImagePicker();
  String? _imageUrl;  // URL after upload to Firebase Storage
  String detectionResult = ""; // Default result

  TextEditingController _titleController = TextEditingController();
  TextEditingController _brandController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  String _selectedSize = "S"; // Default size selection
  late OnnxService _onnxService;  // ONNX service instance

  @override
  void initState() {
    super.initState();
    _onnxService = OnnxService();  // Initialize ONNX service
    _onnxService.initializeModel(); // Load ONNX model
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      // Automatically detect category using ONNX model
      _detectCategory(_image!);
    }
  }

  Future<void> _detectCategory(File imageFile) async {
    // Preprocess the image to match the input shape required by your model
    List<List<List<List<double>>>> preprocessedImage = await _preprocessImage(imageFile);
  
    // Call runInference and get the top prediction
    String topPrediction = await _onnxService.runInference(preprocessedImage);
  
    setState(() {
      detectionResult = topPrediction;
    });
  }

  Future<List<List<List<List<double>>>>> _preprocessImage(File imageFile) async {
    // Load the image
    final Uint8List imageData = await imageFile.readAsBytes();
    final img.Image? originalImage = img.decodeImage(imageData); // Decode the image

    // Calculate new dimensions while maintaining aspect ratio
    final int targetSize = 224;
    int newWidth = targetSize;
    int newHeight = targetSize;

    if (originalImage!.width > originalImage.height) {
      newHeight = (originalImage.height * targetSize / originalImage.width).round();
    } else {
      newWidth = (originalImage.width * targetSize / originalImage.height).round();
    }

    // Resize the image with maintained aspect ratio
    final img.Image resizedImage = img.copyResize(
      originalImage,
      width: newWidth,
      height: newHeight,
    );

    // Create a blank 224x224 canvas and draw the resized image centered on it
    final img.Image canvas = img.Image(targetSize, targetSize)
      ..fill(img.getColor(0, 0, 0)); // Fill with black or any other background color

    img.drawImage(
      canvas,
      resizedImage,
      dstX: (targetSize - newWidth) ~/ 2,
      dstY: (targetSize - newHeight) ~/ 2,
    );

    // Prepare the image data in float32 format for model input
    List<List<List<List<double>>>> preprocessedImage = List.generate(
      1,
      (i) => List.generate(
        3,
        (j) => List.generate(
          targetSize,
          (k) => List.generate(
            targetSize,
            (l) {
              int index = (k * targetSize + l) * 4;
              int pixel = canvas.getPixel(l, k);

              switch (j) {
                case 0:
                  return img.getRed(pixel) / 255.0; // Normalize red channel
                case 1:
                  return img.getGreen(pixel) / 255.0; // Normalize green channel
                case 2:
                  return img.getBlue(pixel) / 255.0; // Normalize blue channel
                default:
                  return 0.0;
              }
            },
          ),
        ),
      ),
    );

    return preprocessedImage;
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
      'category': detectionResult, // Use the detection result here
      'size': _selectedSize, // Store the selected size
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
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

                    // Display the detected result
                    Text(
                      'Detected category: $detectionResult',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),

                    // Title TextField
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(labelText: 'Title'),
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
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      decoration: InputDecoration(labelText: 'Price'),
                    ),
                    SizedBox(height: 16),

                    // Size Dropdown
                    DropdownButton<String>(
                      value: _selectedSize,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedSize = newValue!;
                        });
                      },
                      items: <String>['S', 'M', 'L', 'XL', 'XXL']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      isExpanded: true,
                    ),
                    SizedBox(height: 32),

                    // Save Button at the bottom
                    ElevatedButton(
                      onPressed: () async {
                        await _uploadImage();  // Upload image first
                        _saveClothing();       // Save clothing data
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text('Save Clothing', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}