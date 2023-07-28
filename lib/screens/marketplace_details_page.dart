import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../interface/product.dart';
import 'marketplace_create_product.dart';

class MarketplaceDetailsPage extends StatelessWidget {
  Stream<List<Product>> readProduct() {
    return FirebaseFirestore.instance
        .collection('marketplace')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return Product.fromJson(doc.data());
            }).toList());
  }

  Widget buildProductCard(Product product) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                height: 200, // give a fixed height
                child: Image.network(
                  product.imageUrl != null
                      ? product.imageUrl
                      : 'https://firebasestorage.googleapis.com/v0/b/farmersconnect-21f53.appspot.com/o/placeholder_image.png?alt=media&token=b13cca4d-26d2-452d-8d74-29e160114424', // replace with your placeholder image path
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.network(
                      'https://firebasestorage.googleapis.com/v0/b/farmersconnect-21f53.appspot.com/o/placeholder_image.png?alt=media&token=b13cca4d-26d2-452d-8d74-29e160114424', // replace with your placeholder image path
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        )),
                    Text(
                        'Price: \$${product.price.toDouble().toStringAsFixed(2)}'),
                    Text('Address: ${product.add}'),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Marketplace',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
        backgroundColor: Colors.green, // Make the title bar green color
      ),
      body: Column(children: [
        Expanded(
            child: StreamBuilder<List<Product>>(
          stream: readProduct(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
              return Text("Unable to Load");
            } else if (snapshot.hasData) {
              final products = snapshot.data!;
              return ListView(
                children: products.map(buildProductCard).toList(),
              );
            } else {
              return Text("LOADING");
            }
          },
        )),
      ]),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green, // Make the floating button green color
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MarketplaceProductCreate()),
          );
        },
      ),
    );
  }
}
