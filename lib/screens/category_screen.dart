import 'package:flipkart_clone/features/category/category_controller.dart';
import 'package:flipkart_clone/features/products/grid_product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoriesScreen extends ConsumerWidget {
  final List<Map<String, String>> categories = [
    {'name': 'For You', 'icon': 'assets/images/cat/foryou.png'},
    {'name': 'Mobiles', 'icon': 'assets/images/cat/mobile_transparent.png'},
    {
      'name': 'Electronics',
      'icon': 'assets/images/cat/electronics_transparent.png',
    },
    {'name': 'Fashion', 'icon': 'assets/images/cat/fashion_transparent.png'},
    {
      'name': 'Appliances',
      'icon': 'assets/images/cat/appliances_transparent.png',
    },
    {'name': 'Bikes', 'icon': 'assets/images/cat/smartgadgets_transparent.png'},
    {'name': 'Sports', 'icon': 'assets/images/cat/sports_transparent.png'},
    {
      'name': 'Smart Gadgets',
      'icon': 'assets/images/cat/smartgadgets_transparent.png',
    },
    {
      'name': 'Food & Health',
      'icon': 'assets/images/cat/foodhealth_transparent.png',
    },
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);

    // Screen size
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Sizes
    final categoryBarWidth = screenWidth * 0.25;
    final categoryIconSize = screenWidth * 0.07;
    final categoryFontSize = screenWidth * 0.032;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        title: Container(
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                "Search for products",
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.shopping_cart_outlined,
              color: Colors.black87,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Row(
        children: [
          // LEFT CATEGORY BAR
          Container(
            width: categoryBarWidth,
            color: Colors.grey.shade100,
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final isSelected =
                    categories[index]['name'] == selectedCategory;
                return InkWell(
                  onTap: () {
                    ref.read(selectedCategoryProvider.notifier).state =
                        categories[index]['name']!;
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.022,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.grey.shade100,
                      border: isSelected
                          ? const Border(
                              left: BorderSide(color: Colors.blue, width: 3),
                            )
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          categories[index]['icon']!,
                          height: categoryIconSize,
                          // color: isSelected ? Colors.blue : Colors.black54,
                        ),
                        SizedBox(height: screenHeight * 0.008),
                        Text(
                          categories[index]['name']!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected ? Colors.blue : Colors.black87,
                            fontSize: categoryFontSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // RIGHT PRODUCTS GRID
          Expanded(
            child: Container(
              color: Colors.white,
              child: Consumer(
                builder: (context, ref, _) {
                  final productsAsync = ref.watch(
                    categoryProductsProvider(selectedCategory),
                  );

                  return productsAsync.when(
                    data: (products) => GridView.builder(
                      padding: const EdgeInsets.all(8),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: screenWidth > 600 ? 4 : 2,
                        childAspectRatio: 0.59,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductCard(product: product);
                      },
                    ),
                    loading: () => const Center(
                      child: CircularProgressIndicator(color: Colors.blue),
                    ),
                    error: (e, _) => Center(
                      child: Text(
                        'Error: $e',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
