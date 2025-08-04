import 'package:flipkart_clone/controller/product_provider.dart';

import 'package:flipkart_clone/features/products/grid_product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LazyProductGrid extends ConsumerWidget {
  const LazyProductGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final categoryKey = selectedCategory ?? 'ALL';

    final productsState = ref.watch(paginatedProductsProvider(categoryKey));
    ref.read(paginatedProductsProvider(categoryKey).notifier);

    print("lazy loaded");

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          GridView.builder(
            itemCount: productsState.products.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.80,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              return ProductCard(product: productsState.products[index]);
            },
          ),

          const SizedBox(height: 12),

          // ✅ Correct state-based footer (loading or done)
          if (productsState.isLoading)
            const Center(child: CircularProgressIndicator())
          else if (!productsState.hasMore)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Center(
                child: Text(
                  "✅ All products loaded",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
            )
          else
            const SizedBox(),
        ],
      ),
    );
  }
}
