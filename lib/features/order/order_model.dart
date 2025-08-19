import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String orderId;
  final String title;
  final String imageURL;
  final double price;
  final int quantity;
  final String paymentMethod;
  final String status;
  final String address;
  final DateTime orderedAt;

  OrderModel({
    required this.orderId,
    required this.title,
    required this.imageURL,
    required this.price,
    required this.quantity,
    required this.paymentMethod,
    required this.status,
    required this.address,
    required this.orderedAt,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      orderId: map['orderId'] ?? '',
      title: map['title'] ?? '',
      imageURL: map['imageURL'] ?? '',
      price: (map['price'] as num).toDouble(),
      quantity: map['quantity'] ?? 1,
      paymentMethod: map['paymentMethod'] ?? '',
      status: map['status'] ?? 'Pending',
      address: map['address'] ?? '',
      orderedAt: (map['orderedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'title': title,
      'imageURL': imageURL,
      'price': price,
      'quantity': quantity,
      'paymentMethod': paymentMethod,
      'status': status,
      'address': address,
      'orderedAt': orderedAt,
    };
  }
}
