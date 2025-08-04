import 'package:flipkart_clone/controller/product_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../features/auth/presentation/category_product_list_screen.dart';

// ✅ Add this import

class CategoryBar extends ConsumerWidget {
  CategoryBar({super.key});

  final List<Map<String, dynamic>> categories = [
    {'title': 'Grocery', 'icon': Icons.local_grocery_store},
    {'title': 'Mobiles', 'icon': Icons.phone_android},
    {'title': 'Laptops', 'icon': Icons.laptop},
    {'title': 'Speakers', 'icon': Icons.speaker},
    {'title': 'Accessories', 'icon': Icons.electrical_services_rounded},
    // {'title': 'Appliances', 'icon': Icons.kitchen},
    // {'title': 'Toys', 'icon': Icons.toys},
    // {'title': 'Beauty', 'icon': Icons.brush},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("category bar");
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        padding: const EdgeInsets.symmetric(horizontal: 25),
        itemBuilder: (context, index) {
          final item = categories[index];
          final isSelected = item['title'] == selectedCategory;

          return GestureDetector(
            onTap: () {
              final selected = item['title'];

              // 🔄 Update selected category in provider
              ref.read(selectedCategoryProvider.notifier).state =
                  selected == selectedCategory ? null : selected;
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: isSelected
                        ? Colors.blue
                        : Colors.blue[100],
                    radius: 28,
                    child: Icon(
                      item['icon'],
                      color: isSelected ? Colors.white : Colors.blue[900],
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item['title'],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected ? Colors.blue[900] : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
