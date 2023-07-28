// Import the PlantDiseaseDetectionPage
import 'package:flutter/material.dart';

import 'plant_disease_detection_page.dart';

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
        color: Colors.green, // Change the background color of the card to green
        child: Padding(
          padding: EdgeInsets.all(16.0), // Add padding to the Card
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.local_florist,
                  size: 80.0,
                  color: Colors.white), // Change the color of the icon to white
              SizedBox(height: 8.0),
              Text(
                'Plant Disease Detector',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white, // Change the color of the text to white
                  fontWeight: FontWeight.bold, // Make the font bold
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
