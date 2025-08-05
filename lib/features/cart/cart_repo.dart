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

  // Stream cart items
  Stream<List<CartItem>> getCartItems() {
    return _firestore
        .collection("users")
        .doc(userId)
        .collection('cart')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => CartItem.fromMap(doc.data()),
              ) // <-- uses 'productId'
              .toList(),
        );
  }
}
