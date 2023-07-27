import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String name;
  String add;
  double price;
  GeoPoint loc;
  String id;
  String imageUrl; // add this

  Product(
      {this.id = '',
      required this.name,
      required this.add,
      required this.price,
      required this.loc,
      required this.imageUrl // add this
      });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'add': add,
        'price': price,
        'loc': loc,
        'imageUrl': imageUrl, // add this
      };

  static Product fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        add: json['add'] ?? '',
        price: json['price'] ?? 0.0,
        loc: json['loc'] ?? GeoPoint(0, 0),
        imageUrl: json['imageUrl'] ?? '', // add this
      );
}
