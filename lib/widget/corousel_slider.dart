import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

final bannerImages = [
  'https://rukminim1.flixcart.com/fk-p-flap/3240/540/image/f2ffab1767893241.jpg?q=60', // Tech Sale Banner
  'https://rukminim1.flixcart.com/fk-p-flap/3240/540/image/06418e5fbc0a84a5.jpeg?q=60',
  'https://rukminim1.flixcart.com/fk-p-flap/3240/540/image/aebcb225a4b8d127.jpeg?q=60',
  'https://rukminim1.flixcart.com/fk-p-flap/3240/540/image/f13424f211d7469f.jpeg?q=60', // Fashion Sale Banner
];

class BannerCarousel extends StatelessWidget {
  const BannerCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    print("corousel built");
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: CarouselSlider(
        options: CarouselOptions(
          height: 180,
          autoPlay: true,
          enlargeCenterPage: true,
          viewportFraction: 0.95,
        ),
        items: bannerImages.map((url) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              url,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          );
        }).toList(),
      ),
    );
  }
}
