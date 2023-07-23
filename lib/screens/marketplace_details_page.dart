// marketplace_details_page.dart
import 'package:flutter/material.dart';

class MarketplaceDetailsPage extends StatelessWidget {
  final List<Map<String, dynamic>> items = [
    {
      'image': '/assets/images/carrots.jpeg',
      'name': 'Carrots',
      'price': 10,
      'quantity': 5,
      'date': '07/19/2023'
    },
    {
      'image': '/assets/images/tomatoes.jpeg',
      'name': 'Tomatoes',
      'price': 12,
      'quantity': 10,
      'date': '07/15/2023'
    },
    {
      'image': '/assets/images/potatoes.jpeg',
      'name': 'Potatoes',
      'price': 15,
      'quantity': 7,
      'date': '07/18/2023'
    },
    // Add more items as required
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Marketplace'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.green, width: 2.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Image.network(
                    item['image'],
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['name'],
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4.0),
                        Text('Price: \$${item['price']}'),
                        Text('Quantity: ${item['quantity']}'),
                        Text('Posted Date: ${item['date']}'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
