import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flipkart_clone/features/wishlist/wishlist_model.dart';
import 'package:flipkart_clone/features/wishlist/wishlist_repo.dart';
import 'package:flipkart_clone/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final wishlistStreamProvider = StreamProvider<List<WishlistItem>>((ref) {
  final repo = WishlistRepo();
  return repo.getWishlist();
});

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistAsync = ref.watch(wishlistStreamProvider);

    return wishlistAsync.when(
      data: (wishlistItems) {
        if (wishlistItems.isEmpty) {
          return Center(child: Text('Your wishlist is empty'));
        }

        return ListView.builder(
          itemCount: wishlistItems.length,
          itemBuilder: (context, index) {
            final wishlistItem = wishlistItems[index];

            return FutureBuilder<ProductModel?>(
              future: fetchProductById(wishlistItem.productId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListTile(title: Text('Loading...'));
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return ListTile(title: Text('Product not found'));
                } else {
                  final product = snapshot.data!;
                  return ListTile(
                    leading: Image.network(product.imageURL),
                    title: Text(product.title),
                    subtitle: Text('₹${product.price}'),
                    // add more UI or actions here
                  );
                }
              },
            );
          },
        );
      },
      loading: () => Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error loading wishlist')),
    );
  }

  Future<ProductModel?> fetchProductById(String productId) async {
    final query = await FirebaseFirestore.instance
        .collection('products')
        .where('id', isEqualTo: productId)
        .limit(1)
        .get();

    if (query.docs.isEmpty) return null;
    return ProductModel.fromMap(query.docs.first.data());
  }
}
