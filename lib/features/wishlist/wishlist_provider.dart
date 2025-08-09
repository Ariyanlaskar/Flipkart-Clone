import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipkart_clone/controller/product_provider.dart';
import 'package:flipkart_clone/model/product_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'wishlist_repo.dart';
import 'wishlist_model.dart';

final wishlistRepoProvider = Provider<WishlistRepo>((ref) {
  return WishlistRepo();
});

final wishlistStreamProvider = StreamProvider.autoDispose<List<WishlistItem>>((
  ref,
) {
  final user = ref
      .watch(authStateProvider)
      .value; // get current user (User? or null)

  if (user == null) {
    // no user logged in, empty wishlist
    return Stream.value([]);
  }

  final repo = WishlistRepo();
  return repo.getWishlistStream(user.uid); // stream wishlist of logged in user
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
  final querySnapshot = await FirebaseFirestore.instance
      .collection('products')
      .where('id', isEqualTo: productId) // Query by product field `id`
      .limit(1)
      .get();

  if (querySnapshot.docs.isEmpty) {
    throw Exception('Product not found');
  }

  return ProductModel.fromMap(querySnapshot.docs.first.data());
});
