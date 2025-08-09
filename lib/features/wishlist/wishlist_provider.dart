import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipkart_clone/model/product_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'wishlist_repo.dart';
import 'wishlist_model.dart';

final wishlistRepoProvider = Provider<WishlistRepo>((ref) => WishlistRepo());

final wishlistStreamProvider = StreamProvider<List<WishlistItem>>((ref) {
  final repo = ref.watch(wishlistRepoProvider);
  return repo.getWishlist();
});

final wishlistControllerProvider = Provider<WishlistController>((ref) {
  final repo = ref.watch(wishlistRepoProvider);
  return WishlistController(repo);
});

class WishlistController {
  final WishlistRepo _repo;
  WishlistController(this._repo);

  Future<void> addToWishlist(String productId) async {
    await _repo.addToWishlist(productId);
  }

  Future<void> removeFromWishlist(String productId) async {
    await _repo.removeFromWishlist(productId);
  }
}

final productByIdProvider = FutureProvider.family<ProductModel, String>((
  ref,
  productId,
) async {
  final doc = await FirebaseFirestore.instance
      .collection('products')
      .doc(productId)
      .get();
  if (!doc.exists) throw Exception('Product not found');
  return ProductModel.fromMap(doc.data()!);
});
