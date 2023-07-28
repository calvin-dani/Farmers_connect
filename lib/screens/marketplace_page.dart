// marketplace_page.dart
import 'package:flutter/material.dart';

import 'marketplace_details_page.dart'; // Import the MarketplaceDetailsPage

class MarketplaceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MarketplaceDetailsPage()),
        );
      },
      child: Card(
        color: Colors.green, // Change the background color of the card to green
        child: Padding(
          padding: EdgeInsets.all(16.0), // Add padding to the Card
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_cart,
                  size: 80.0,
                  color: Colors.white), // Change the color of the icon to white
              SizedBox(height: 8.0),
              Text(
                'Marketplace',
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
