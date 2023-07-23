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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart, size: 80.0, color: Colors.green),
            SizedBox(height: 8.0),
            Text('Marketplace', style: TextStyle(fontSize: 18.0)),
          ],
        ),
      ),
    );
  }
}
