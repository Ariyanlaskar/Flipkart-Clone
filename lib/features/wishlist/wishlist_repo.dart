import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipkart_clone/model/product_model.dart';
import 'wishlist_model.dart';

class WishlistRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get userId => _auth.currentUser?.uid;

  Future<void> addToWishlist(String productDocId) async {
    final uid = userId;
    if (uid == null) return;

    final wishlistRef = _firestore
        .collection('users')
        .doc(uid)
        .collection('wishlist')
        .doc(productDocId); // Use product doc ID as wishlist doc ID

    final doc = await wishlistRef.get();

    if (!doc.exists) {
      await wishlistRef.set({
        'productId': productDocId,
        'addedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> removeFromWishlist(String productDocId) async {
    final uid = userId;
    if (uid == null) return;

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('wishlist')
        .doc(productDocId)
        .delete();
  }

  Stream<List<WishlistItem>> getWishlist() {
    final uid = userId;
    if (uid == null) {
      return const Stream.empty();
    }

    return _firestore
        .collection('users')
        .doc(uid)
        .collection('wishlist')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => WishlistItem.fromMap(doc.data()))
              .toList(),
        );
  }
}

Future<ProductModel?> getProductByDocId(String productDocId) async {
  final docSnap = await FirebaseFirestore.instance
      .collection('products')
      .doc(productDocId)
      .get();

  if (!docSnap.exists) return null;

  return ProductModel.fromMap(docSnap.data()!);
}
