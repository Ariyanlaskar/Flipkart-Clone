import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipkart_clone/screens/cart_screen.dart';
import 'package:flipkart_clone/screens/search_screen.dart';
import 'package:flipkart_clone/controller/product_provider.dart'; // <-- for cartItemsProvider

PreferredSizeWidget buildFlipkartAppBar(BuildContext context, WidgetRef ref) {
  final cartItems = ref.watch(cartItemsProvider);
  int totalQuantity = 0;

  cartItems.whenData((items) {
    totalQuantity = items.fold(0, (sum, item) => sum + item.quantity);
  });

  final screenWidth = MediaQuery.of(context).size.width;

  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: const Color(0xFF2874F0),
    elevation: 0,
    title: Row(
      children: [
        Image.asset(
          'assets/images/flipkart_logo.png',
          height: MediaQuery.of(context).size.height * 0.045,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              height: 38,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SearchScreen()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1565C0),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.white70, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Search for products, brands and more",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: screenWidth < 350 ? 12 : 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // 🛒 Cart Icon with badge
        Stack(
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartScreen()),
                );
              },
              icon: const Icon(Icons.shopping_cart, color: Colors.white),
            ),
            if (totalQuantity > 0)
              Positioned(
                right: 4,
                top: 4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                  ),
                  child: Text(
                    '$totalQuantity',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),

        // 👤 Profile Icon
        Builder(
          builder: (context) => IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(Icons.person_outline, color: Colors.white),
          ),
        ),
      ],
    ),
  );
}
