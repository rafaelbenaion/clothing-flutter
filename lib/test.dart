import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:onnxruntime/onnxruntime.dart';

class OnnxService {
  // Singleton instance
  static final OnnxService _instance = OnnxService._internal();

  // Loaded ONNX session (kept in memory)
  late OrtSession _session;
  late List<String> _labels; // List to hold labels

  // Map of clothing-related labels for filtering
  final Map<int, String> clothingLabels = {
    267: "abaya",
    411: "apron",
    414: "backpack, back pack, knapsack, packsack, rucksack, haversack",
    433: "bathing cap, swimming cap",
    438: "bearskin, busby, shako",
    444: "bikini, two-piece",
    451: "bolo tie, bolo, bola tie, bola",
    452: "bonnet, poke bonnet",
    456: "bow tie, bow-tie, bowtie",
    459: "brassiere, bra, bandeau",
    474: "cardigan",
    501: "cloak",
    514: "cowboy boot",
    515: "cowboy hat, ten-gallon hat",
    517: "crash helmet",
    553: "feather boa, boa",
    597: "jean, blue jean, denim",
    598: "jersey, T-shirt, tee shirt",
    614: "kimono",
    615: "knee pad",
    616: "knot (related context for accessories)",
    638: "maillot",
    639: "maillot, tank suit",
    686: "military uniform",
    654: "miniskirt, mini",
  };

  // Private constructor (singleton)
  OnnxService._internal();

  // Factory constructor to return the singleton instance
  factory OnnxService() {
    return _instance;
  }

  // Initialize the ONNX model (this should be called only once)
  Future<void> initializeModel() async {
    print('Initializing ONNX model...');

    try {
      // Initialize the ONNX Runtime environment
      OrtEnv.instance.init();

      // Load the MobileNet model from assets (update with your actual model path)
      const modelFileName = 'lib/assets/mobilenetv2-7.onnx';
      final rawAssetFile = await rootBundle.load(modelFileName);
      final modelBytes = rawAssetFile.buffer.asUint8List();

      // Load labels from the asset file
      await _loadLabels();

      // Create session options
      final sessionOptions = OrtSessionOptions();

      // Create and store the ONNX session in memory
      _session = OrtSession.fromBuffer(modelBytes, sessionOptions);
      print('ONNX model initialized successfully.');
    } catch (e) {
      print('Error initializing ONNX model: $e');
      throw Exception('Failed to initialize ONNX model');
    }
  }

  // Load labels from the assets file
  Future<void> _loadLabels() async {
    final labelsData = await rootBundle.loadString('lib/assets/synset.txt');
    _labels = labelsData.split('\n');
    print('Labels loaded successfully.');
  }

  // Run inference using the pre-loaded ONNX model
  Future<String> runInference(List<List<List<List<double>>>> preprocessedImage) async {
    try {
      print('Running ONNX inference...');

      // Flatten the preprocessed image data
      List<List<double>> flattenedImage = preprocessedImage
          .expand((channel) => channel.expand((row) => row))
          .toList();

      // Convert the flattened image data to Float32List
      Float32List float32Image = Float32List.fromList(
        flattenedImage.map((e) => e.map((v) => v.toDouble()).toList()).expand((e) => e).toList()
      );

      // Prepare input tensor for the image (1, 3, 224, 224) as required by MobileNet
      final imageTensor = OrtValueTensor.createTensorWithDataList(float32Image, [1, 3, 224, 224]);

      print('Input tensor for image created with length: ${float32Image.length}');

      // Define the input map with the correct tensor name
      final inputs = {   
        'data': imageTensor, // Use 'data' as the input name
      };

      // Create OrtRunOptions object
      final runOptions = OrtRunOptions();

      print('Running inference...');
      final outputs = _session.run(runOptions, inputs);
      print('Inference completed.');

      // Extract the classification probabilities
      final nestedProbabilities = outputs[0]?.value as List<List<double>>?;
      if (nestedProbabilities == null) {
        throw Exception('Failed to get probabilities from the model output.');
      }

      // Flattening the nested List<List<double>> to List<double>
      List<double> probabilities = nestedProbabilities.expand((e) => e).toList();

      // Filter only clothing-related predictions using specified labels and order by highest confidence
      List<MapEntry<int, double>> clothingPredictions = probabilities
          .asMap()
          .entries
          .where((entry) => clothingLabels.containsKey(entry.key)) // Filter to only clothing labels
          .toList();
      clothingPredictions.sort((a, b) => b.value.compareTo(a.value)); // Sort by confidence descending

      // Determine the top clothing prediction
      if (clothingPredictions.isNotEmpty && clothingPredictions.first.value > 0) {
        String topLabel = clothingLabels[clothingPredictions.first.key]!;
        print('Top Clothing Prediction: $topLabel');
        return topLabel;
      } else {
        // If all predictions are negative, return "Other"
        print('Top Clothing Prediction: Other');
        return "Other";
      }
    } catch (e) {
      print('Error during ONNX inference: $e');
      throw Exception('Inference failed');
    }
  }
}