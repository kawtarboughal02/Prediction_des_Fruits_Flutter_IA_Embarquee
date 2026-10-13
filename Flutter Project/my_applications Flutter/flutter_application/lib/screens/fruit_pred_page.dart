import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:flutter/foundation.dart';

class FruitPredictionPage extends StatefulWidget {
  @override
  _FruitPredictionPageState createState() => _FruitPredictionPageState();
}

class _FruitPredictionPageState extends State<FruitPredictionPage> {
  File? _image;
  Uint8List? _webImage;
  String _label = 'Aucun fruit détecté';
  double _confidence = 0.0;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      String? result = await Tflite.loadModel(
        model: "assets/model/model.tflite",
        labels: "assets/model/labels.txt",
      );
      if (result == null) {
        print("Erreur lors du chargement du modèle.");
      } else {
        print("Modèle chargé avec succès.");
      }
    } catch (e) {
      print("Erreur de chargement du modèle : $e");
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    if (kIsWeb && source == ImageSource.camera) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("La caméra n'est pas disponible sur le web.")),
      );
      return;
    }

    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);

    if (pickedImage != null) {
      if (kIsWeb) {
        final bytes = await pickedImage.readAsBytes();
        setState(() {
          _webImage = bytes;
          _image = null;
          // flutter_tflite effectue l'inférence sur mobile (Android/iOS).
          _label = 'Inférence TFLite disponible sur mobile';
          _confidence = 0.0;
        });
      } else {
        final imageFile = File(pickedImage.path);
        setState(() {
          _image = imageFile;
          _webImage = null;
          _label = 'Analyse en cours...';
          _confidence = 0.0;
        });
        _classifyImage(imageFile);
      }
    } else {
      print("Aucune image sélectionnée.");
    }
  }

  Future<void> _classifyImage(File image) async {
    try {
      var recognitions = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 3,
        threshold: 0.5,
        imageMean: 127.5,
        imageStd: 127.5,
      );

      if (recognitions != null && recognitions.isNotEmpty) {
        setState(() {
          _label = recognitions[0]['label']; 
          _confidence = recognitions[0]['confidence'] * 100; 
        });
      } else {
        setState(() {
          _label = 'Aucun fruit détecté';
          _confidence = 0.0;
        });
      }
    } catch (e) {
      print("Erreur lors de la classification : $e");
      setState(() {
        _label = 'Erreur de classification';
        _confidence = 0.0;
      });
    }
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fruit Prediction"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Afficher l'image sélectionnée
            if (_webImage != null)
              Image.memory(_webImage!,
                  height: 200, width: 200, fit: BoxFit.cover)
            else if (_image != null)
              Image.file(_image!, height: 200, width: 200, fit: BoxFit.cover)
            else
              const Text("Aucune image sélectionnée",
                  style: TextStyle(fontSize: 18)),

            const SizedBox(height: 20),

            Text(
              "Nom du fruit : $_label",
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Text(
              "Confiance : ${_confidence.toStringAsFixed(2)}%",
              style: const TextStyle(fontSize: 18, color: Colors.black54),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Prendre un Caméra"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo),
                  label: const Text("Importer Votre Photo dans la Galerie"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
