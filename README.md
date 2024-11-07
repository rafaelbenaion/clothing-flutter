
# Clothing Recognition App

This project is a Flutter-based clothing app that allows users to log in, browse clothing items, view item details, and add items to their cart. The app also uses an ONNX machine learning model to classify clothing items based on images, adding a layer of intelligent recognition to the user experience.

## Project Structure and Assets

### Machine Learning Model
The app uses a **MobileNetV2 ONNX model** to classify clothing items. This model is stored in the `assets/models` directory and accepts input images of shape `[1, 3, 224, 224]`.

- **Model Path**: `lib/assets/mobilenetv2-7.onnx`
- **Input Name**: `data`

The app's `onnx_service.dart` file handles loading and running inference with the model. It filters the prediction results to display only clothing-related classifications from a predefined list.

### Firebase Integration
Firebase is used for user authentication, real-time data storage, and file storage within this app. The `firebase_auth` package manages user login, and `firebase_storage` is used for handling and storing user-uploaded images. The Firebase configuration is found in `firebase_options.dart`, which is generated through Firebase's CLI.

### Test Images
Sample test images are provided in the `assets/images/test_images` folder. You can use these images to verify the model’s predictions within the app.

### Test Users
To simplify testing, you can log in using the following demo accounts:

1. **Email**: `test@mail.com`
   - **Password**: `test123`
2. **Email**: `lucas@mail.com`
   - **Password**: `test123`

## Setup and Installation

To run this project, follow these instructions to set up Flutter, install dependencies, and launch the app.

### Prerequisites
- **Flutter SDK**: Make sure you have Flutter installed. Follow the [Flutter installation guide](https://flutter.dev/docs/get-started/install) if needed.
- **Dart SDK**: Flutter comes with Dart, but make sure it's included in your environment.

### Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/your-repo/clothing-recognition-app.git
   cd clothing-recognition-app
   ```

2. Install the required dependencies:
   ```bash
   flutter pub get
   ```

3. Make sure your `assets` directory contains the following:
   - **ONNX Model**: `lib/assets/mobilenetv2-7.onnx`
   - **ONNX Labels**: `lib/assets/synset.txt`

4. Configure Firebase:
   - Ensure Firebase is properly configured in `firebase_options.dart`.

### Running the Application

1. Start the Flutter app:
   ```bash
   flutter run
   ```

   This will launch the app on your connected device or emulator.

2. Log in with one of the provided test accounts to explore the app's features:
   - **Email**: `test@mail.com`
     - **Password**: `test123`
   - **Email**: `lucas@mail.com`
     - **Password**: `test123`

## Code Overview

- **Authentication**: User login and authentication are managed through Firebase. See `login_page.dart` for details.
- **Main Navigation**: 
  - **Home**: Defined in `home_page.dart`.
  - **Buy**: Page for browsing items, located in `buy_page.dart`.
  - **Detail**: Page showing individual item details, found in `detail_page.dart`.
  - **Cart**: Displays selected items, managed in `cart_page.dart`.
  - **Profile**: Shows user profile information, editable in `profile_page.dart`.

### ONNX Model Service
The `onnx_service.dart` file handles the model loading and inference operations. The `initializeModel` function loads the MobileNetV2 model and the `_loadLabels` function loads the labels for classification. The `runInference` function processes input images and returns the most likely clothing label prediction.

### Testing the Model

To test the model:
1. Open the "Add Page" to upload a sample image.
2. Select a test image from `assets/images/test_images` to see the prediction output.

## Dependencies

Key dependencies include:
- **`flutter_onnx`**: For running ONNX models in Flutter.
- **`firebase_auth`** and **`firebase_storage`**: For handling user authentication and image storage.

You can find the full list of dependencies in `pubspec.yaml`.

## Troubleshooting

- **Model Load Issues**: Ensure the model file path in `onnx_service.dart` matches the actual path.
- **Authentication Issues**: Double-check Firebase configuration in `firebase_options.dart`.
