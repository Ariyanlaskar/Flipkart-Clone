import 'package:flipkart_clone/features/wishlist/wishlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Widget buildWishlistButton(
  BuildContext context,
  WidgetRef ref,
  String productId,
) {
  final wishlistAsync = ref.watch(wishlistStreamProvider);
  final wishlistController = ref.read(wishlistControllerProvider);

  return wishlistAsync.when(
    data: (wishlistItems) {
      final isInWishlist = wishlistItems.any(
        (item) => item.productId == productId,
      );

      return IconButton(
        icon: Icon(
          isInWishlist ? Icons.favorite : Icons.favorite_border,
          color: isInWishlist ? Colors.red : Colors.grey,
        ),
        onPressed: () async {
          if (isInWishlist) {
            await wishlistController.removeFromWishlist(productId);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Removed from wishlist')),
            );
          } else {
            await wishlistController.addToWishlist(productId);
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Added to wishlist')));
          }
        },
      );
    },
    loading: () => const CircularProgressIndicator(),
    error: (e, _) => const Icon(Icons.error),
  );
}
