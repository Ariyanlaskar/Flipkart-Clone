import 'package:flipkart_clone/controller/product_provider.dart';
import 'package:flipkart_clone/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipkart_clone/features/cart/cart_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  Future<ProductModel?> _getProductDetails(String productId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('products')
          .doc(productId) // ← Firestore doc ID
          .get();

      if (doc.exists) {
        final data = doc.data();
        if (data != null) {
          // ✅ set ID from doc.id, not from 'id' field
          return ProductModel.fromMap({...data, 'id': doc.id});
        }
      }
    } catch (e) {
      debugPrint('Error fetching product: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItemsAsync = ref.watch(cartItemsProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        backgroundColor: const Color(0xFF2874F0),
      ),
      body: cartItemsAsync.when(
        data: (cartItems) {
          if (cartItems.isEmpty) {
            return const Center(child: Text('Your cart is empty.'));
          }

          return FutureBuilder<List<Map<String, dynamic>>>(
            future: Future.wait(
              cartItems.map((item) async {
                final product = await _getProductDetails(item.productId);
                return {'product': product, 'quantity': item.quantity};
              }),
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data == null) {
                return const Center(child: Text('Your cart is empty.'));
              }
              final enrichedCart = snapshot.data!
                  .where((e) => e['product'] != null)
                  .toList();

              if (enrichedCart.isEmpty) {
                return const Center(child: Text('Your cart is empty.'));
              }

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: enrichedCart.length,
                      itemBuilder: (context, index) {
                        final data = enrichedCart[index];
                        final ProductModel product = data['product'];
                        final int quantity = data['quantity'];

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(
                                  product.imageURL,
                                  width: screenWidth * 0.2,
                                  height: screenWidth * 0.2,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.title,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        "₹${product.price.toStringAsFixed(0)}",
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.remove_circle_outline,
                                            ),
                                            onPressed: () async {
                                              if (quantity > 1) {
                                                await ref
                                                    .read(
                                                      cartRepositoryProvider,
                                                    )
                                                    .updateQuantity(
                                                      product.id,
                                                      quantity - 1,
                                                    );
                                              } else {
                                                await ref
                                                    .read(
                                                      cartRepositoryProvider,
                                                    )
                                                    .removeFromcart(product.id);
                                              }
                                            },
                                          ),
                                          Text('$quantity'),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.add_circle_outline,
                                            ),
                                            onPressed: () async {
                                              await ref
                                                  .read(cartRepositoryProvider)
                                                  .updateQuantity(
                                                    product.id,
                                                    quantity + 1,
                                                  );
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () async {
                                    await ref
                                        .read(cartRepositoryProvider)
                                        .removeFromcart(product.id);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  _buildBottomSection(enrichedCart),
                ],
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: \$err')),
      ),
    );
  }

  Widget _buildBottomSection(List<Map<String, dynamic>> enrichedCart) {
    final total = enrichedCart.fold<double>(
      0.0,
      (sum, data) => sum + (data['product'].price * data['quantity']),
    );

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey, width: 0.3)),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                "Total: ₹${total.toStringAsFixed(0)}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Add checkout logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFB641B),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text('Place Order'),
            ),
          ],
        ),
      ),
    );
  }
}
