import 'package:flipkart_clone/features/products/grid_product_card.dart';
import 'package:flipkart_clone/widget/appbar.dart';
import 'package:flipkart_clone/widget/categorybar.dart';
import 'package:flipkart_clone/widget/corousel_slider.dart';
import 'package:flipkart_clone/widget/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipkart_clone/controller/product_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: buildFlipkartAppBar(context, ref),
      body: const HomeContent(),
    );
  }
}

class HomeContent extends ConsumerWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final categoryKey = selectedCategory ?? 'ALL';
    final productsState = ref.watch(paginatedProductsProvider(categoryKey));
    final notifier = ref.read(paginatedProductsProvider(categoryKey).notifier);

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (scrollInfo.metrics.pixels >=
                scrollInfo.metrics.maxScrollExtent - 200 &&
            !productsState.isLoading &&
            productsState.hasMore) {
          notifier.fetchNext();
        }
        return false;
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 15,
              ),
              child: const Text(
                "Top Categories",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            CategoryBar(),
            const Divider(),
            Container(
              color: const Color.fromARGB(255, 245, 244, 244),
              child: const BannerCarousel(),
            ),
            const DealsOfTheDaySection(),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
              child: Text(
                selectedCategory ?? 'All Products',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ProductGridWithLoader(categoryKey: categoryKey),
          ],
        ),
      ),
    );
  }
}

class DealsOfTheDaySection extends ConsumerWidget {
  const DealsOfTheDaySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dealsAsync = ref.watch(dealOfTheDayProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: Text(
            "Deals of the Day",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 220,
          child: dealsAsync.when(
            data: (products) => ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              itemBuilder: (_, i) => ProductCard(product: products[i]),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text("Error: $e"),
          ),
        ),
      ],
    );
  }
}

class ProductGridWithLoader extends ConsumerWidget {
  final String categoryKey;
  const ProductGridWithLoader({super.key, required this.categoryKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(paginatedProductsProvider(categoryKey));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          GridView.builder(
            itemCount: state.products.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.80,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              return ProductCard(product: state.products[index]);
            },
          ),
          const SizedBox(height: 12),
          if (state.isLoading)
            const Center(child: CircularProgressIndicator())
          else if (!state.hasMore)
            const Padding(
              padding: EdgeInsets.all(12),
              child: Center(
                child: Text(
                  "✅ All products loaded",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
