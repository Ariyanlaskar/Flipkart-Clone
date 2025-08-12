import 'package:flipkart_clone/widget/shimmers/wishlist_shimmer.dart';
import 'package:flutter/material.dart';

class NetworkImageWithShimmer extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;

  const NetworkImageWithShimmer({
    Key? key,
    required this.imageUrl,
    this.width = 80,
    this.height = 80,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: BoxFit.cover,
      // Here is the key part:
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child; // Image loaded
        // While loading, show shimmer:
        return WishlistItemShimmer(width: width, height: height);
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width,
          height: height,
          color: Colors.grey.shade300,
          child: const Icon(Icons.broken_image, color: Colors.grey),
        );
      },
    );
  }
}
