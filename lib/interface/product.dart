

import 'package:cloud_firestore/cloud_firestore.dart';

class Product{
  String name;
  String add;
  double price;
  GeoPoint loc;
  String id;
  
  Product({
    this.id ='',
    required this.name,
    required this.add,
    required this.price,
    required this.loc
  });

  Map<String,dynamic> toJson() => {
    'id': id,
    'name': name,
    'add' : add,
    'price' : price,
    'loc' : loc,
  };

  static Product fromJson(Map<String,dynamic> json) => Product(
    id: json['id'],
    name: json['name'],
    add: json['add'],
    price: json['price'],
    loc: json['loc'],
  );

}