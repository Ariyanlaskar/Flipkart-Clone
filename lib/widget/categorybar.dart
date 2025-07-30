import 'package:flutter/material.dart';

class CategoryBar extends StatelessWidget {
  final List<Map<String, dynamic>> categories = [
    {'title': 'Grocery', 'icon': Icons.local_grocery_store},
    {'title': 'Mobiles', 'icon': Icons.phone_android},
    {'title': 'Fashion', 'icon': Icons.checkroom},
    {'title': 'Electronics', 'icon': Icons.electrical_services},
    {'title': 'Home', 'icon': Icons.home},
    {'title': 'Appliances', 'icon': Icons.kitchen},
    {'title': 'Toys', 'icon': Icons.toys},
    {'title': 'Beauty', 'icon': Icons.brush},
  ];

  CategoryBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemBuilder: (context, index) {
          final item = categories[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue[100],
                  radius: 28,
                  child: Icon(item['icon'], color: Colors.blue[900], size: 28),
                ),
                const SizedBox(height: 6),
                Text(item['title'], style: const TextStyle(fontSize: 12)),
              ],
            ),
          );
        },
      ),
    );
  }
}
