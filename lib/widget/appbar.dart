import 'package:flutter/material.dart';

PreferredSizeWidget buildFlipkartAppBar(BuildContext context) {
  print("appbar built");
  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: const Color(0xFF2874F0),
    elevation: 0,
    title: Row(
      children: [
        Image.asset('assets/images/flipkart_logo.png', height: 28),
        const SizedBox(width: 8),
        const Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              height: 38,
              child: TextField(
                style: TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: "Search for products, brands and more",
                  hintStyle: TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Color(0xFF1565C0),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.search, color: Colors.white70),
                ),
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            // Your cart logic
          },
          icon: const Icon(Icons.shopping_cart, color: Colors.white),
        ),
        Builder(
          // Important: allows access to Scaffold.of(context)
          builder: (context) => IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer(); // This opens the drawer
            },
            icon: const Icon(Icons.person_outline, color: Colors.white),
          ),
        ),
      ],
    ),
  );
}
