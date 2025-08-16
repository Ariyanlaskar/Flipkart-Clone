import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> uploadProductsToFirestore() async {
  // Load JSON file
  final String jsonString = await rootBundle.loadString(
    'assets/data/appliance_products.json',
  );
  final List<dynamic> products = json.decode(jsonString);

  final firestore = FirebaseFirestore.instance;

  for (var product in products) {
    await firestore.collection('products').add({
      'id': product['id'], // keep product id inside document
      'title': product['title'],
      'description': product['description'],
      'price': product['price'],
      'discount': product['discount'],
      'imageURL': product['imageURL'],
      'category': product['category'],
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  print("✅ All products uploaded successfully!");
}
