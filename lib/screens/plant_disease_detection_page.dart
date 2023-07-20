import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class PlantDiseaseDetectionPage extends StatefulWidget {
  @override
  _PlantDiseaseDetectionPageState createState() =>
      _PlantDiseaseDetectionPageState();
}

class _PlantDiseaseDetectionPageState extends State<PlantDiseaseDetectionPage> {
  File? _imageFile;
  String? _diseaseName;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          _diseaseName =
              null; // Reset the disease name when a new image is picked
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  // Function to detect the disease based on the image
  // Replace this with your actual disease detection logic
  void _detectDisease() {
    // Simulate a delay for demonstration purposes
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _diseaseName =
            "Some Disease"; // Replace with the actual detected disease name
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plant Disease Detection'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_imageFile != null)
              Expanded(
                child: Image.file(_imageFile!),
              )
            else
              Expanded(
                child: Icon(Icons.camera_alt, size: 100.0),
              ),
            SizedBox(height: 20.0),
            if (_imageFile != null)
              Flexible(
                child: Image.file(_imageFile!),
              )
            else
              Flexible(
                child: Icon(Icons.camera_alt, size: 100.0),
              ),
            SizedBox(height: 20.0),
            if (_diseaseName != null)
              Text('Detected Disease: $_diseaseName',
                  style: TextStyle(fontSize: 18.0)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _detectDisease,
        tooltip: 'Detect Disease',
        child: Icon(Icons.check),
      ),
    );
  }
}
