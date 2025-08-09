import 'package:flipkart_clone/controller/product_provider.dart';
import 'package:flipkart_clone/features/wishlist/wishlist_provider.dart';

import 'package:flipkart_clone/model/product_model.dart';
import 'package:flipkart_clone/widget/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductDetailScreen extends ConsumerWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 248, 248),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF2874F0),
        title: Text(
          product.title,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageCarousel([product.imageURL], screenWidth, ref),

                _buildTitleAndPrice(context, product, screenWidth),
                _buildRating(product),
                _buildFlipkartAssured(),
                _buildOffers(product),
                _buildSpecifications(product),
                const SizedBox(height: 80), // leave room for bottom bar
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildImageCarousel(
    List<String> images,
    double screenWidth,
    WidgetRef ref,
  ) {
    final wishlistAsync = ref.watch(wishlistStreamProvider);
    final wishlistController = ref.read(wishlistControllerProvider);

    return wishlistAsync.when(
      data: (wishlistItems) {
        final isInWishlist = wishlistItems.any(
          (item) => item.productId == product.id,
        );

        return Container(
          height: screenWidth * 0.75,
          color: Colors.white,
          child: Column(
            children: [
              const SizedBox(height: 20),
              Stack(
                children: [
                  Hero(
                    tag: product.imageURL,
                    child: Image.network(
                      product.imageURL,
                      height: screenWidth * 0.63,
                      fit: BoxFit.contain,
                      width: screenWidth,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85),
                        shape: BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(
                          isInWishlist ? Icons.favorite : Icons.favorite_border,
                          color: isInWishlist ? Colors.red : Colors.grey[700],
                          size: 28,
                        ),
                        tooltip: isInWishlist
                            ? 'Remove from wishlist'
                            : 'Add to wishlist',
                        onPressed: () async {
                          if (isInWishlist) {
                            await wishlistController.removeFromWishlist(
                              product.id,
                            );
                            ScaffoldMessenger.of(ref.context).showSnackBar(
                              const SnackBar(
                                content: Text('Removed from wishlist'),
                              ),
                            );
                          } else {
                            await wishlistController.addToWishlist(product.id);
                            ScaffoldMessenger.of(ref.context).showSnackBar(
                              const SnackBar(
                                content: Text('Added to wishlist'),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
      loading: () => Container(
        height: screenWidth * 0.75,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(),
      ),
      error: (e, st) => Container(
        height: screenWidth * 0.75,
        alignment: Alignment.center,
        child: const Icon(Icons.error, color: Colors.red),
      ),
    );
  }

  Widget _buildTitleAndPrice(
    BuildContext context,
    ProductModel p,
    double screenWidth,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: 12,
      ),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            p.title,
            style: TextStyle(
              fontSize: screenWidth * 0.045,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '₹${p.price.toInt()}',
                style: TextStyle(
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '₹${p.mrp.toInt()}',
                style: const TextStyle(
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '${p.discount.toInt()}% off',
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRating(ProductModel p) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: Colors.white,
      width: double.infinity,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Text(
                  "${p.rating}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(Icons.star, size: 14, color: Colors.white),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            "${p.reviews} Ratings & Reviews",
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildFlipkartAssured() {
    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 4, bottom: 4),
      child: Image.asset('assets/images/fa_as.logo.png', height: 24),
    );
  }

  Widget _buildOffers(ProductModel p) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(top: 8),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Available Offers",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          ...p.offers.map(
            (offer) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.local_offer_outlined,
                    size: 18,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      offer,
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecifications(ProductModel p) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.white,
      margin: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Specifications",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(p.specifications, style: const TextStyle(color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonHeight = screenWidth * 0.14;

    return SafeArea(
      child: Container(
        height: buttonHeight,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey, width: 0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Consumer(
            builder: (context, ref, _) {
              return Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.shopping_cart_outlined, size: 20),
                      label: Text(
                        "Add to Cart",
                        style: TextStyle(fontSize: screenWidth * 0.040),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange.shade700,
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      onPressed: () async {
                        final CartRepo = ref.read(cartRepositoryProvider);
                        print(
                          'Add to cart tapped for product title: ${product.title}, id: ${product.id}',
                        );
                        await CartRepo.addToCart(product.id);
                        // Fluttertoast.showToast(
                        //   msg: "Added to cart",
                        //   toastLength: Toast.LENGTH_SHORT,
                        //   gravity: ToastGravity.BOTTOM,
                        //   backgroundColor: Colors.black87,
                        //   textColor: Colors.white,
                        //   fontSize: 14.0,
                        // );
                        showCustomToast(context, "Added to cart");
                      },
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.flash_on_outlined, size: 20),
                      label: Text(
                        "Buy Now",
                        style: TextStyle(fontSize: screenWidth * 0.040),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFB641B),
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
