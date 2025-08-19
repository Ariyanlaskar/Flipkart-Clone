import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ItemShimmer extends StatelessWidget {
  const ItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: SizedBox(
        width: double.infinity,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thumbnail (fixed size)
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 12),

                // Content (flexible)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title (full width of remaining space)
                      Container(
                        height: 18,
                        width: screenWidth * 0.5, // half screen width
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 8),

                      // Subtitle 1
                      Container(
                        height: 14,
                        width: screenWidth * 0.35,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 8),

                      // Subtitle 2
                      Container(
                        height: 14,
                        width: screenWidth * 0.25,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 12),

                      // Buttons Row
                      Row(
                        children: [
                          Container(
                            height: 30,
                            width: screenWidth * 0.25, // 25% of screen
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(width: 8),
                          Container(
                            height: 30,
                            width: screenWidth * 0.15, // 15% of screen
                            color: Colors.grey.shade400,
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
      ),
    );
  }
}
