import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Itemshimer extends StatelessWidget {
  const Itemshimer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: SizedBox(
        width: double.infinity, // Make sure it fills horizontal space
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          shadowColor: Colors.black12,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80, // reduced from 100
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(width: 16), // reduced spacing a bit
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize
                        .min, // avoid expanding vertically unnecessarily
                    children: [
                      Container(
                        height: 20,
                        width: double.infinity,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 16,
                        width: 120, // reduced from 150
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 16,
                        width: 100,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisSize:
                            MainAxisSize.min, // prevents overflow horizontally
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 30,
                            width: 100,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(width: 12), // spacing between buttons
                          Container(
                            height: 30,
                            width: 70,
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
