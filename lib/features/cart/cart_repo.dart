import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipkart_clone/features/cart/cart_model.dart';

class CartRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get userId => _auth.currentUser?.uid;

  // Add or update product in cart
  Future<void> addToCart(String productId) async {
    final uid = userId;
    if (uid == null) return;

    try {
      final query = await _firestore
          .collection("products")
          .where('id', isEqualTo: productId)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        throw Exception('Product with id=$productId not found');
      }

      final docId = query.docs.first.id;

      final cartRef = _firestore
          .collection("users")
          .doc(uid)
          .collection("cart")
          .doc(docId);

      final doc = await cartRef.get();
      if (doc.exists) {
        await cartRef.update({'quantity': FieldValue.increment(1)});
      } else {
        await cartRef.set({
          'productId': docId,
          'quantity': 1,
          'addedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error adding to cart: $e');
    }
  }

  // Remove from cart
  Future<void> removeFromcart(String productId) async {
    final uid = userId;
    if (uid == null) return;

    await _firestore
        .collection("users")
        .doc(uid)
        .collection('cart')
        .doc(productId)
        .delete();
  }

  // Update cart items
  Future<void> updateQuantity(String productId, int newQuantity) async {
    final uid = userId;
    if (uid == null) return;

    final cartRef = _firestore
        .collection("users")
        .doc(uid)
        .collection("cart")
        .doc(productId);

    if (newQuantity > 0) {
      await cartRef.update({'quantity': newQuantity});
    } else {
      await cartRef.delete();
    }
  }

  //  Updated to take UID
  Stream<List<CartItem>> getCartItems(String uid) {
    return _firestore
        .collection("users")
        .doc(uid)
        .collection('cart')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => CartItem.fromMap(doc.data())).toList(),
        );
  }

  // Checkout Logic
  Future<void> checkoutCart() async {
    final uid = userId;
    if (uid == null) return;

    try {
      final cartSnapshot = await _firestore
          .collection("users")
          .doc(uid)
          .collection("cart")
          .get();

      if (cartSnapshot.docs.isEmpty) {
        throw Exception("Cart is empty");
      }

      double totalAmount = 0.0;
      List<Map<String, dynamic>> orderItems = [];

      for (var doc in cartSnapshot.docs) {
        final data = doc.data();
        final productSnapshot = await _firestore
            .collection("products")
            .doc(data['productId'])
            .get();

        if (!productSnapshot.exists) continue;

        final productData = productSnapshot.data()!;
        final price = (productData['price'] ?? 0).toDouble();
        final quantity = data['quantity'] ?? 1;

        totalAmount += price * quantity;

        orderItems.add({
          'productId': data['productId'],
          'quantity': quantity,
          'price': price,
        });
      }

      // Save order to Firestore
      final orderRef = _firestore
          .collection("users")
          .doc(uid)
          .collection("orders")
          .doc();

      await orderRef.set({
        'orderId': orderRef.id,
        'items': orderItems,
        'totalAmount': totalAmount,
        'status': 'pending',
        'orderedAt': FieldValue.serverTimestamp(),
      });

      // Clear cart after checkout
      final batch = _firestore.batch();
      for (var doc in cartSnapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      print("Checkout successful");
    } catch (e) {
      print("Checkout error: $e");
    }
  }
}
