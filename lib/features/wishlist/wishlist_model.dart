import 'package:cloud_firestore/cloud_firestore.dart';

class WishlistItem {
  final String productId;
  final DateTime? addedAt;

  WishlistItem({required this.productId, this.addedAt});

  factory WishlistItem.fromMap(Map<String, dynamic> map) {
    return WishlistItem(
      productId: map['productId'],
      addedAt: (map['addedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {'productId': productId, 'addedAt': FieldValue.serverTimestamp()};
  }
}
