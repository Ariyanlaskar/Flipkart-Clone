import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flipkart_clone/controller/product_provider.dart';
import 'package:flipkart_clone/features/wishlist/wishlist_model.dart';
import 'package:flipkart_clone/features/wishlist/wishlist_provider.dart';
import 'package:flipkart_clone/features/wishlist/wishlist_repo.dart';
import 'package:flipkart_clone/model/product_model.dart';
import 'package:flipkart_clone/screens/product_details_screen.dart';
import 'package:flipkart_clone/widget/shimmer_loading_screen.dart';
import 'package:flipkart_clone/widget/shimmers/wishlist_shimmer.dart';
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
    final width = MediaQuery.of(context).size.width;

    final isTablet = width > 800;
    final isSmallPhone = width < 360;

    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          title: const Text("Wishlist"),
          backgroundColor: const Color(0xFF2874F0),
          foregroundColor: Colors.white,
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
                      size: isSmallPhone ? 70 : 100,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Your wishlist is empty',
                      style: TextStyle(
                        fontSize: isSmallPhone ? 18 : 22,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              );
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                final isWideScreen = constraints.maxWidth > 600;
                final horizontalPadding = isWideScreen
                    ? 24.0
                    : isSmallPhone
                    ? 8.0
                    : 12.0;
                final imageSize = isWideScreen
                    ? 100.0
                    : isSmallPhone
                    ? 65.0
                    : 80.0;
                final cardElevation = isWideScreen ? 8.0 : 3.0;

                return ListView.separated(
                  padding: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: horizontalPadding,
                  ),
                  itemCount: wishlistItems.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final wishlistItem = wishlistItems[index];

                    return FutureBuilder<ProductModel?>(
                      future: fetchProductById(wishlistItem.productId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return WishlistItemShimmer(
                            width: double.infinity,
                            height: 100,
                          );
                        } else if (!snapshot.hasData || snapshot.data == null) {
                          return Card(
                            elevation: cardElevation,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
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
                            child: Card(
                              elevation: cardElevation,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(14),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ProductDetailScreen(product: product),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(
                                    isSmallPhone ? 10 : 16,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: SizedBox(
                                          width: imageSize,
                                          height: imageSize,
                                          child: NetworkImageWithShimmer(
                                            imageUrl: product.imageURL,
                                          ),
                                        ),
                                      ),

                                      SizedBox(width: isWideScreen ? 20 : 12),

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
                                                fontSize: isSmallPhone
                                                    ? 14
                                                    : isWideScreen
                                                    ? 20
                                                    : 16,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Wrap(
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              spacing: 8,
                                              children: [
                                                Text(
                                                  '₹${product.price.toStringAsFixed(0)}',
                                                  style: TextStyle(
                                                    fontSize: isSmallPhone
                                                        ? 14
                                                        : 16,
                                                    color: Colors.deepOrange,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                if (product.discount > 0) ...[
                                                  Text(
                                                    '₹${product.mrp.toStringAsFixed(0)}',
                                                    style: TextStyle(
                                                      fontSize: isSmallPhone
                                                          ? 12
                                                          : 14,
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 6,
                                                          vertical: 2,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Colors.green.shade600,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            4,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      '${product.discount.toStringAsFixed(0)}% OFF',
                                                      style: TextStyle(
                                                        fontSize: isSmallPhone
                                                            ? 11
                                                            : 13,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              product.specifications,
                                              maxLines: isSmallPhone ? 1 : 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: isSmallPhone
                                                    ? 12
                                                    : 14,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      InkWell(
                                        borderRadius: BorderRadius.circular(20),
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
                                          padding: EdgeInsets.all(
                                            isSmallPhone ? 6 : 10,
                                          ),
                                          child: Icon(
                                            Icons.favorite,
                                            color: Colors.red.shade700,
                                            size: isSmallPhone ? 22 : 28,
                                          ),
                                        ),
                                      ),
                                    ],
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
