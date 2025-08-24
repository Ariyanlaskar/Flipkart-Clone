import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipkart_clone/features/order/order_model.dart';

class OrderRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> placeOrder({
    required String productId,
    required String title,
    required String imageURL,
    required double price,
    required int quantity,
    required String paymentMethod,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception("User not logged in");

    final orderRef = _firestore
        .collection("users")
        .doc(uid)
        .collection("orders")
        .doc();

    await orderRef.set({
      "orderId": orderRef.id,
      "productId": productId,
      "title": title,
      "imageURL": imageURL,
      "price": price,
      "quantity": quantity,
      "status": "Pending",
      "address": "Dummy Address, Pune, India",
      "paymentMethod": paymentMethod,
      "orderedAt": FieldValue.serverTimestamp(),
    });
  }

  // for adding items from cart
  Future<void> placeOrderFromCart(String paymentMethod) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception("User not logged in");

    final cartRef = _firestore.collection("users").doc(uid).collection("cart");
    final cartSnapshot = await cartRef.get();

    if (cartSnapshot.docs.isEmpty) throw Exception("Cart is empty");

    final batch = _firestore.batch();

    for (var doc in cartSnapshot.docs) {
      final data = doc.data();
      final orderRef = _firestore
          .collection("users")
          .doc(uid)
          .collection("orders")
          .doc();

      batch.set(orderRef, {
        "orderId": orderRef.id,
        "productId": data["productId"],
        "title": data["title"],
        "imageURL": data["imageURL"],
        "price": data["price"],
        "quantity": data["quantity"],
        "status": "Pending",
        "address": "Dummy Address, Pune, India",
        "paymentMethod": paymentMethod,
        "orderedAt": FieldValue.serverTimestamp(),
      });

      batch.delete(cartRef.doc(doc.id));
    }

    await batch.commit();
  }

  Stream<List<OrderModel>> getOrders() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return const Stream.empty();

    return _firestore
        .collection("users")
        .doc(uid)
        .collection("orders")
        .orderBy("orderedAt", descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return OrderModel.fromMap(doc.data() as Map<String, dynamic>);
          }).toList();
        });
  }
}
