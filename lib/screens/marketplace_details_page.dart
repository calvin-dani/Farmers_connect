// marketplace_details_page.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../interface/product.dart';
import 'marketplace_create_product.dart';

class MarketplaceDetailsPage extends StatelessWidget {

  Widget buildProducts(Product product) => ListTile(
    title: Text(product.name)
  );

  Stream<List<Product>> readProduct() {
    return FirebaseFirestore.instance.collection('marketplace').snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) {
              print(doc.data());
              print("HERE");
              return Product.fromJson(doc.data());
            }
             ).toList());
  }

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
      body: Column(children: [
        Text('Welcome back, CalShek!', style: TextStyle(fontSize: 24.0)),
        Expanded(
          child: ListView.builder(
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
        ),
        Expanded(child: StreamBuilder<List<Product>>(
          stream: readProduct(),
          builder: (context, snapshot) {
            if(snapshot.hasError){
              print(snapshot.error);
              return Text("Unable to Load");
            }
            else if (snapshot.hasData){
              final products = snapshot.data!;
              return ListView(
                children: products.map(buildProducts).toList()
              );
            }
            else{
              return Text("LOADING");
            }
          } ,
        )),
        Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MarketplaceProductCreate()),
                        );
                      },
                      icon: Icon(Icons.add))),
              SizedBox(width: 16.0),
              Expanded(
                  child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MarketplaceProductCreate()),
                        );
                      },
                      icon: Icon(Icons.add))), // Corrected here
            ],
          ),
        ),
      ]),
    );
  }
}
