// marketplace_page.dart
import 'package:flutter/material.dart';

class MarketplaceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Implement the navigation to the Marketplace page here
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart, size: 80.0),
            SizedBox(height: 8.0),
            Text('Marketplace', style: TextStyle(fontSize: 18.0)),
          ],
        ),
      ),
    );
  }
}
