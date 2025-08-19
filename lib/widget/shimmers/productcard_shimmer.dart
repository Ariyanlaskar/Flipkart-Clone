import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductCardShimmer extends StatelessWidget {
  const ProductCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: 140, // 🔹 match ProductCard
        margin: const EdgeInsets.only(right: 12), // 🔹 match spacing
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image placeholder
            Container(
              height: 100, // 🔹 match ProductCard image size
              width: 100,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(height: 8),
            // Title placeholder
            Container(height: 14, width: 100, color: Colors.grey.shade400),
            const SizedBox(height: 6),
            // Price placeholder
            Container(height: 14, width: 60, color: Colors.grey.shade400),
            const SizedBox(height: 6),
            // Discount placeholder
            Container(height: 12, width: 50, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}
