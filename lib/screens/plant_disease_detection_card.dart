import 'package:flutter/material.dart';
import 'plant_disease_detection_page.dart'; // Make sure the path is correct

class PlantDiseaseDetectionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PlantDiseaseDetectionPage()),
        );
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.local_florist, size: 100.0),
            Text('Plant Disease Detector', style: TextStyle(fontSize: 18.0)),
          ],
        ),
      ),
    );
  }
}
