import 'package:flipkart_clone/screens/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flipkart_clone/model/product_model.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width < 380
            ? MediaQuery.of(context).size.width * 0.72
            : 140,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, // ✅ allows shrinking
          children: [
            /// 🔹 Image Section (shrinkable)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height < 750
                      ? 80
                      : 100, // ✅ shrink if small height
                  width: MediaQuery.of(context).size.height < 750 ? 80 : 100,
                  child: Image.network(
                    product.imageURL,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image, size: 60),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 6),

            /// 🔹 Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                product.title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12), // ✅ slightly smaller
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            /// 🔹 Price
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: Text(
                "₹${product.price.toStringAsFixed(0)}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12, // ✅ shrink font
                ),
              ),
            ),

            /// 🔹 Discount
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                "${product.discount.toStringAsFixed(0)}% off",
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 11,
                ), // ✅ shrink font
              ),
            ),

            const SizedBox(height: 6), // smaller bottom padding
          ],
        ),
      ),
    );
  }
}
