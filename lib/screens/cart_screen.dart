import 'package:flipkart_clone/controller/product_provider.dart';
import 'package:flipkart_clone/model/product_model.dart';
import 'package:flipkart_clone/screens/checkout_screen.dart';
import 'package:flipkart_clone/screens/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  Future<ProductModel?> _getProductDetails(String productId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .get();
      if (doc.exists) {
        final data = doc.data();
        if (data != null) {
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2874F0),
        centerTitle: true,
        title: const Text(
          'My Cart',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        elevation: 4,
      ),
      body: cartItemsAsync.when(
        data: (cartItems) {
          if (cartItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 100,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Your cart is empty!',
                    style: TextStyle(fontSize: 22, color: Colors.black54),
                  ),
                ],
              ),
            );
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
                return const Center(child: Text('Your cart is empty!'));
              }

              final enrichedCart = snapshot.data!
                  .where((e) => e['product'] != null)
                  .toList();

              if (enrichedCart.isEmpty) {
                return const Center(child: Text('Your cart is empty!'));
              }

              return LayoutBuilder(
                builder: (context, constraints) {
                  final isTablet = constraints.maxWidth > 600;

                  return Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: isTablet
                              ? 110
                              : 120 + MediaQuery.of(context).padding.bottom,
                          left: 8,
                          right: 8,
                        ),
                        child: ListView.separated(
                          padding: EdgeInsets.symmetric(
                            horizontal: isTablet ? 36 : 12,
                            vertical: 12,
                          ),
                          itemCount: enrichedCart.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 20),
                          itemBuilder: (context, index) {
                            final data = enrichedCart[index];
                            final ProductModel product = data['product'];
                            final int quantity = data['quantity'];

                            return InkWell(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProductDetailScreen(product: product),
                                ),
                              ),
                              child: Card(
                                elevation: 6,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                shadowColor: Colors.black12,
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Stack(
                                        children: [
                                          Container(
                                            width: isTablet ? 130 : 100,
                                            height: isTablet ? 130 : 100,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black12,
                                                  blurRadius: 12,
                                                  offset: const Offset(0, 6),
                                                ),
                                              ],
                                              color: Colors.white,
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: Image.network(
                                                product.imageURL,
                                                fit: BoxFit.contain,
                                                loadingBuilder:
                                                    (context, child, progress) {
                                                      if (progress == null)
                                                        return child;
                                                      return const Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      );
                                                    },
                                                errorBuilder:
                                                    (context, _, __) =>
                                                        const Icon(
                                                          Icons.error_outline,
                                                          size: 40,
                                                          color:
                                                              Colors.redAccent,
                                                        ),
                                              ),
                                            ),
                                          ),
                                          if (product.discount > 0)
                                            Positioned(
                                              top: 6,
                                              left: 6,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 6,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.green[700],
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      color: Colors.black26,
                                                      blurRadius: 4,
                                                      offset: Offset(1, 1),
                                                    ),
                                                  ],
                                                ),
                                                child: Text(
                                                  '${product.discount.toStringAsFixed(0)}% OFF',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              product.title,
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: isTablet ? 20 : 16,
                                                fontWeight: FontWeight.w600,
                                                height: 1.3,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Row(
                                              children: [
                                                Text(
                                                  '₹${product.price.toStringAsFixed(0)}',
                                                  style: TextStyle(
                                                    fontSize: isTablet
                                                        ? 20
                                                        : 16,
                                                    color: Colors.deepOrange,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                if (product.discount > 0) ...[
                                                  Text(
                                                    '₹${product.mrp.toStringAsFixed(0)}',
                                                    style: TextStyle(
                                                      fontSize: isTablet
                                                          ? 16
                                                          : 14,
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 6),
                                                ],
                                              ],
                                            ),
                                            if (product.discount > 0)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 6,
                                                ),
                                                child: Text(
                                                  'Save ₹${(product.mrp - product.price).toStringAsFixed(0)} more with Flipkart',
                                                  style: TextStyle(
                                                    fontSize: isTablet
                                                        ? 14
                                                        : 12,
                                                    color: Colors.green[800],
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            const SizedBox(height: 14),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                _QuantitySelector(
                                                  quantity: quantity,
                                                  onIncrement: () async {
                                                    await ref
                                                        .read(
                                                          cartRepositoryProvider,
                                                        )
                                                        .updateQuantity(
                                                          product.id,
                                                          quantity + 1,
                                                        );
                                                  },
                                                  onDecrement: () async {
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
                                                          .removeFromcart(
                                                            product.id,
                                                          );
                                                    }
                                                  },
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    await ref
                                                        .read(
                                                          cartRepositoryProvider,
                                                        )
                                                        .removeFromcart(
                                                          product.id,
                                                        );
                                                  },
                                                  style: TextButton.styleFrom(
                                                    foregroundColor:
                                                        Colors.redAccent,
                                                    textStyle: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  child: const Text('Remove'),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: _BottomBar(
                          enrichedCart: enrichedCart,
                          isTablet: isTablet,
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

class _QuantitySelector extends StatelessWidget {
  final int quantity;
  final Future<void> Function() onIncrement;
  final Future<void> Function() onDecrement;

  const _QuantitySelector({
    Key? key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey.shade200,
      ),
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onDecrement,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              child: Icon(Icons.remove, size: 20, color: Colors.black87),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Text(
              quantity.toString(),
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onIncrement,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              child: Icon(Icons.add, size: 20, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatefulWidget {
  final List<Map<String, dynamic>> enrichedCart;
  final bool isTablet;

  const _BottomBar({
    required this.enrichedCart,
    required this.isTablet,
    Key? key,
  }) : super(key: key);

  @override
  State<_BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<_BottomBar> {
  bool _isExpanded = false; // Collapsed by default for cleaner UI

  @override
  Widget build(BuildContext context) {
    final total = widget.enrichedCart.fold<double>(
      0,
      (sum, data) => sum + (data['product'].price * data['quantity']),
    );
    final taxEstimate = total * 0.18; // 18% GST
    final deliveryEstimate = 40; // Flat delivery fee

    return Align(
      alignment: Alignment.bottomCenter,
      child: SafeArea(
        top: false,
        bottom: true,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Toggle Header
              InkWell(
                onTap: () => setState(() => _isExpanded = !_isExpanded),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: widget.isTablet ? 48 : 20,
                    vertical: widget.isTablet ? 16 : 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Price Details',
                        style: TextStyle(
                          fontSize: widget.isTablet ? 18 : 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Icon(
                        _isExpanded
                            ? Icons.keyboard_arrow_down
                            : Icons.keyboard_arrow_up,
                        size: widget.isTablet ? 28 : 24,
                      ),
                    ],
                  ),
                ),
              ),

              // Expanded Section
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: widget.isTablet ? 48 : 20,
                    vertical: widget.isTablet ? 20 : 16,
                  ),
                  child: Column(
                    children: [
                      _buildRow('Subtotal', '₹${total.toStringAsFixed(0)}'),
                      const SizedBox(height: 6),
                      _buildRow(
                        'GST (18%)',
                        '₹${taxEstimate.toStringAsFixed(0)}',
                        color: Colors.grey.shade700,
                      ),
                      const SizedBox(height: 6),
                      _buildRow(
                        'Delivery Charges',
                        '₹${deliveryEstimate.toStringAsFixed(0)}',
                        color: Colors.grey.shade700,
                      ),
                      const Divider(height: 20, thickness: 1.2),
                    ],
                  ),
                ),
                crossFadeState: _isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 250),
              ),

              // Total & Checkout Button (always visible)
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: widget.isTablet ? 48 : 20,
                  vertical: widget.isTablet ? 20 : 16,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Total: ₹${(total + taxEstimate + deliveryEstimate).toStringAsFixed(0)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: widget.isTablet ? 22 : 18,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: widget.enrichedCart.isEmpty
                          ? null
                          : () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => CheckoutScreen(
                              //       cartItems: widget.enrichedCart,
                              //     ),
                              //   ),
                              // );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2874F0),
                        padding: EdgeInsets.symmetric(
                          horizontal: widget.isTablet ? 36 : 28,
                          vertical: widget.isTablet ? 14 : 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 5,
                        shadowColor: Colors.blue.shade700,
                      ),
                      child: Text(
                        'Checkout',
                        style: TextStyle(
                          fontSize: widget.isTablet ? 18 : 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: widget.isTablet ? 16 : 14,
            color: color ?? Colors.black87,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: widget.isTablet ? 16 : 14,
            color: color ?? Colors.black87,
          ),
        ),
      ],
    );
  }
}
