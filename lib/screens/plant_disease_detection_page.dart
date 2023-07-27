import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:tflite/tflite.dart';
import 'package:image/image.dart' as img;
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
// import 'dart:html' as html;

class PlantDiseaseDetectionPage extends StatefulWidget {
  @override
  _PlantDiseaseDetectionPageState createState() =>
      _PlantDiseaseDetectionPageState();
}

class _PlantDiseaseDetectionPageState extends State<PlantDiseaseDetectionPage> {
  File? _imageFile;
  String? _diseaseName;

  String? _imageFileUrl;

  @override
  void initState() {
    super.initState();
    // loadModel();
  }

  Future loadModel() async {
    try {
      // await Tflite.loadModel(
      //   model: "assets/model.tflite",
      //   labels: "assets/labels.txt", // Assuming you have a labels.txt file
      // );
    } catch (e) {
      print('Failed to load model: $e');
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        if (kIsWeb) {
          // final data = await pickedFile.readAsBytes();
          // final blob = html.Blob([data]);
          // final url = html.Url.createObjectUrlFromBlob(blob);
          setState(() {
            // _imageFileUrl = url;
            // _diseaseName =
                null; // Reset the disease name when a new image is picked
          });
          // _detectDisease(data.buffer.asUint8List());
        } else {
          setState(() {
            _imageFile = File(pickedFile.path);
            _diseaseName =
                null; // Reset the disease name when a new image is picked
          });
          var image = img.decodeImage(_imageFile!.readAsBytesSync());
          var resizedImg = img.copyResizeCropSquare(
              image!, 224); // Assuming the model takes 224x224 sized images
          var imgBytes = imageToByteListFloat32(resizedImg, 224, 127.5,
              127.5); // Adjust the parameters according to your model's requirements
          _detectDisease(imgBytes.buffer.asUint8List());
        }
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future _detectDisease(Uint8List imgBytes) async {
    // var recognitions = await Tflite.runModelOnBinary(
    //   binary: imgBytes,
    //   numResults: 2,
    //   threshold: 0.2,
    //   asynch: true,
    // );

    // setState(() {
    //   if (recognitions != null && recognitions.isNotEmpty) {
    //     _diseaseName = recognitions[0]["label"];
    //   } else {
    //     _diseaseName = "Unknown";
    //   }
    // });
  }

  Uint8List imageToByteListFloat32(
      img.Image image, int inputSize, double mean, double std) {
    var convertedBytes = Float32List(1 * inputSize * inputSize * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;
    for (var i = 0; i < inputSize; ++i) {
      for (var j = 0; j < inputSize; ++j) {
        var pixel = image.getPixel(j, i);
        buffer[pixelIndex++] = (img.getRed(pixel) - mean) / std;
        buffer[pixelIndex++] = (img.getGreen(pixel) - mean) / std;
        buffer[pixelIndex++] = (img.getBlue(pixel) - mean) / std;
      }
    }
    return convertedBytes.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plant Disease Detection'),
      ),
      body: Column(
        children: <Widget>[
          // This Expanded widget makes the image take up 3/5th of the screen
          Expanded(
            flex: 3,
            child: Center(
              child: _imageFile != null
                  ? Image.file(_imageFile!)
                  : Icon(Icons.camera_alt, size: 100.0),
            ),
          ),
          // This Expanded widget makes the details card take up 2/5th of the screen
          Expanded(
            flex: 2,
            child: _diseaseName != null
                ? Card(
                    color:
                        Colors.lightGreen[100], // Choose a color that you like
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Detected Disease: $_diseaseName',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          // TODO: Add code to calculate and display the confidence percentage
                          // Text('Confidence: ${confidencePercentage}%'),
                          // TODO: Add code to display the methods to cure the disease
                          // Text('Cure: ${cureMethods}'),
                        ],
                      ),
                    ),
                  )
                : Container(),
          ),
        ],
      ),
      floatingActionButton: Stack(
        children: <Widget>[
          Positioned(
            bottom: 10.0,
            right: 10.0,
            child: FloatingActionButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              tooltip: 'Pick Image from gallery',
              child: Icon(Icons.photo_library),
            ),
          ),
          Positioned(
            bottom: 70.0,
            right: 10.0,
            child: FloatingActionButton(
              onPressed: () => _pickImage(ImageSource.camera),
              tooltip: 'Take a Photo',
              child: Icon(Icons.camera_alt),
            ),
          ),
        ],
      ),
    );
  }
}
