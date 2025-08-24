import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipkart_clone/screens/order_success.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flipkart_clone/features/cart/cart_repo.dart';
import 'package:flipkart_clone/model/product_model.dart';
// or your existing success screen

class BuyCheckoutScreen extends ConsumerWidget {
  const BuyCheckoutScreen({super.key});

  Future<ProductModel?> _getProduct(String productDocId) async {
    final snap = await FirebaseFirestore.instance
        .collection('products')
        .doc(productDocId)
        .get();
    if (!snap.exists || snap.data() == null) return null;
    final data = snap.data()!;
    return ProductModel.fromMap({...data, 'id': snap.id});
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return const Scaffold(
        body: Center(child: Text('Please sign in to continue')),
      );
    }

    final width = MediaQuery.of(context).size.width;
    final isSmall = width < 360;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        centerTitle: true,
        elevation: 1,
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: CartRepo().getCartItems(uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Your cart is empty'));
            }

            final cartItems = snapshot.data!;

            return FutureBuilder<List<_LineItem>>(
              future: Future.wait(
                cartItems.map((ci) async {
                  final product = await _getProduct(ci.productId);
                  if (product == null) return null;
                  return _LineItem(product: product, quantity: ci.quantity);
                }),
              ).then((list) => list.whereType<_LineItem>().toList()),
              builder: (context, fb) {
                if (fb.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final lines = fb.data ?? [];
                if (lines.isEmpty) {
                  return const Center(
                    child: Text('Some items are unavailable'),
                  );
                }

                final subtotal = lines.fold<double>(
                  0,
                  (s, e) => s + (e.product.price * e.quantity),
                );

                return Column(
                  children: [
                    // Dummy address
                    Padding(
                      padding: EdgeInsets.all(isSmall ? 8 : 12),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(isSmall ? 10 : 14),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Color(0xFF2874F0),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Ariyan Laskar\n123, Dummy Street,\nPune, Maharashtra - 411001\nPhone: 7002508034',
                                  style: TextStyle(
                                    fontSize: isSmall ? 14 : 16,
                                    fontWeight: FontWeight.w500,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  'Change',
                                  style: TextStyle(fontSize: isSmall ? 12 : 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Items list
                    Expanded(
                      child: ListView.separated(
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmall ? 8 : 12,
                          vertical: isSmall ? 6 : 10,
                        ),
                        itemCount: lines.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, i) {
                          final line = lines[i];
                          return Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(isSmall ? 10 : 12),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      line.product.imageURL,
                                      width: isSmall ? 56 : 70,
                                      height: isSmall ? 56 : 70,
                                      fit: BoxFit.contain,
                                      errorBuilder: (_, __, ___) =>
                                          const Icon(Icons.image_not_supported),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          line.product.title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: isSmall ? 14 : 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Text(
                                              '₹${line.product.price.toStringAsFixed(0)}',
                                              style: TextStyle(
                                                fontSize: isSmall ? 14 : 16,
                                                color: Colors.deepOrange,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'x${line.quantity}',
                                              style: TextStyle(
                                                fontSize: isSmall ? 12 : 14,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '₹${(line.product.price * line.quantity).toStringAsFixed(0)}',
                                    style: TextStyle(
                                      fontSize: isSmall ? 14 : 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Bottom bar
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          top: BorderSide(color: Colors.grey.shade300),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 8,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: SafeArea(
                        top: false,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isSmall ? 10 : 16,
                            vertical: isSmall ? 10 : 12,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Total: ₹${subtotal.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontSize: isSmall ? 16 : 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2874F0),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isSmall ? 20 : 28,
                                    vertical: isSmall ? 10 : 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () async {
                                  final uid =
                                      FirebaseAuth.instance.currentUser?.uid;
                                  if (uid == null) return;

                                  try {
                                    final userRef = FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(uid);
                                    final cartRef = userRef.collection('cart');
                                    final orderRef = userRef.collection(
                                      'orders',
                                    );

                                    final cartSnap = await cartRef.get();
                                    if (cartSnap.docs.isEmpty) return;

                                    final batch = FirebaseFirestore.instance
                                        .batch();
                                    for (final doc in cartSnap.docs) {
                                      final data = doc.data();
                                      final product = await FirebaseFirestore
                                          .instance
                                          .collection('products')
                                          .doc(data['productId'])
                                          .get();

                                      if (!product.exists) continue;
                                      final productData = product.data()!;
                                      final orderDoc = orderRef.doc();

                                      batch.set(orderDoc, {
                                        "orderId": orderDoc.id,
                                        "productId": data['productId'],
                                        "title":
                                            productData['title'] ?? "No Title",
                                        "imageURL":
                                            productData['imageURL'] ??
                                            "https://via.placeholder.com/150",
                                        "price": productData['price'] ?? 0,
                                        "quantity": data['quantity'] ?? 1,
                                        "status": "Pending",
                                        "address":
                                            "Ariyan Laskar, Dummy Street, Pune",
                                        "paymentMethod": "Cash on Delivery",
                                        "orderedAt":
                                            FieldValue.serverTimestamp(),
                                      });
                                    }

                                    await batch.commit();

                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const OrderSuccessScreen(
                                              productTitle: "All Items",
                                              paymentMethod: "Cash on Delivery",
                                            ),
                                      ),
                                    );

                                    Future.delayed(
                                      const Duration(milliseconds: 500),
                                      () async {
                                        final clearBatch = FirebaseFirestore
                                            .instance
                                            .batch();
                                        final snap = await cartRef.get();
                                        for (final doc in snap.docs) {
                                          clearBatch.delete(doc.reference);
                                        }
                                        await clearBatch.commit();
                                      },
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Order failed: $e'),
                                      ),
                                    );
                                  }
                                },
                                child: Text(
                                  'Place Order',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isSmall ? 14 : 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _LineItem {
  final ProductModel product;
  final int quantity;
  _LineItem({required this.product, required this.quantity});
}
