import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flipkart_clone/controller/product_provider.dart';
import 'package:flipkart_clone/features/wishlist/wishlist_model.dart';
import 'package:flipkart_clone/features/wishlist/wishlist_provider.dart';
import 'package:flipkart_clone/features/wishlist/wishlist_repo.dart';
import 'package:flipkart_clone/model/product_model.dart';
import 'package:flipkart_clone/widget/simple_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final wishlistStreamProvider = StreamProvider.autoDispose<List<WishlistItem>>((
  ref,
) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value([]);
  final repo = WishlistRepo();
  return repo.getWishlistStream(user.uid);
});

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistAsync = ref.watch(wishlistStreamProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Wishlist"),
        backgroundColor: const Color(0xFF2874F0),
        elevation: 3,
        centerTitle: true,
      ),
      body: wishlistAsync.when(
        data: (wishlistItems) {
          if (wishlistItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 100,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Your wishlist is empty',
                    style: TextStyle(fontSize: 22, color: Colors.black54),
                  ),
                ],
              ),
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final isWideScreen = constraints.maxWidth > 600;
              final horizontalPadding = isWideScreen ? 24.0 : 12.0;
              final imageSize = isWideScreen ? 100.0 : 80.0;
              final cardElevation = isWideScreen ? 8.0 : 4.0;

              return ListView.separated(
                padding: EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: horizontalPadding,
                ),
                itemCount: wishlistItems.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final wishlistItem = wishlistItems[index];

                  return FutureBuilder<ProductModel?>(
                    future: fetchProductById(wishlistItem.productId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Card(
                          elevation: cardElevation,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const ListTile(
                            title: Text('Loading...'),
                            leading: CircularProgressIndicator(),
                          ),
                        );
                      } else if (!snapshot.hasData || snapshot.data == null) {
                        return Card(
                          elevation: cardElevation,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const ListTile(
                            title: Text('Product not found'),
                          ),
                        );
                      } else {
                        final product = snapshot.data!;
                        return TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: 1),
                          duration: const Duration(milliseconds: 350),
                          builder: (context, opacity, child) =>
                              Opacity(opacity: opacity, child: child),
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Card(
                              elevation: cardElevation,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              shadowColor: Colors.black26,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () {
                                  // Optional: Navigate to product detail page
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Product Image with shadow
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.1,
                                              ),
                                              blurRadius: 10,
                                              offset: const Offset(0, 5),
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: Image.network(
                                            product.imageURL,
                                            width: imageSize,
                                            height: imageSize,
                                            fit: BoxFit.cover,
                                            loadingBuilder: (context, child, progress) {
                                              if (progress == null)
                                                return child;
                                              return SizedBox(
                                                width: imageSize,
                                                height: imageSize,
                                                child: Center(
                                                  child: CircularProgressIndicator(
                                                    value:
                                                        progress.expectedTotalBytes !=
                                                            null
                                                        ? progress.cumulativeBytesLoaded /
                                                              progress
                                                                  .expectedTotalBytes!
                                                        : null,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),

                                      SizedBox(width: isWideScreen ? 20 : 14),

                                      // Product details expanded
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              product.title,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: isWideScreen
                                                    ? 20
                                                    : 17,
                                                letterSpacing: 0.3,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              children: [
                                                Text(
                                                  '₹${product.price.toStringAsFixed(0)}',
                                                  style: TextStyle(
                                                    fontSize: isWideScreen
                                                        ? 18
                                                        : 16,
                                                    color: Colors.deepOrange,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                const SizedBox(width: 14),
                                                if (product.discount > 0) ...[
                                                  Text(
                                                    '₹${product.mrp.toStringAsFixed(0)}',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 7,
                                                          vertical: 3,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Colors.green.shade600,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            5,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      '${product.discount.toStringAsFixed(0)}% OFF',
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              product.specifications,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: isWideScreen
                                                    ? 15
                                                    : 14,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Remove from wishlist button
                                      Material(
                                        color: Colors.transparent,
                                        shape: const CircleBorder(),
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                          splashColor: Colors.red.withOpacity(
                                            0.3,
                                          ),
                                          onTap: () async {
                                            final wishlistController = ref.read(
                                              wishlistControllerProvider,
                                            );
                                            await wishlistController
                                                .removeFromWishlist(
                                                  wishlistItem.productId,
                                                );
                                            showToast('Removed from wishlist');
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Icon(
                                              Icons.favorite,
                                              color: Colors.red.shade700,
                                              size: isWideScreen ? 32 : 28,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error loading wishlist: $e')),
      ),
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
