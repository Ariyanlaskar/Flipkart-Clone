class CartItem {
  final String productId;
  final int quantity;

  CartItem({required this.productId, required this.quantity});

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      productId: map['productId'], // ← now doc.id, not field id
      quantity: map['quantity'] ?? 1,
    );
  }
}
