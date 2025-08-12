import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class WishlistItemShimmer extends StatelessWidget {
  final double width;
  final double height;

  const WishlistItemShimmer({Key? key, this.width = 80, this.height = 80})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
