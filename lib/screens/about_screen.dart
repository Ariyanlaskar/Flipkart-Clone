import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("About Us"),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/flipkart_logo.png",
                    height: size.width * 0.18,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Flipkart Clone",
                    style: TextStyle(
                      fontSize: size.width * 0.055,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Powered by Flutter • Firebase • Riverpod",
                    style: TextStyle(
                      fontSize: size.width * 0.035,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            _buildSectionCard(
              icon: Icons.store_mall_directory,
              title: "Who We Are",
              description:
                  "This is a Flipkart-style e-commerce app built using Flutter, "
                  "Firebase, and Riverpod. It provides features such as user "
                  "authentication, product listings, cart, wishlist, and "
                  "detailed product pages.",
              size: size,
            ),

            _buildSectionCard(
              icon: Icons.flag_circle_outlined,
              title: "Our Mission",
              description:
                  "To deliver a seamless shopping experience with a modern, "
                  "responsive design and real-time backend integration.",
              size: size,
            ),

            _buildSectionCard(
              icon: Icons.contact_mail_outlined,
              title: "Contact Us",
              description:
                  "📧 Email: ariyanlaskar2002@gmail.com\n"
                  "📞 Phone: +91 7002508034\n"
                  "📍 Location: Pune, Maharashtra",
              size: size,
            ),

            const SizedBox(height: 40),

            Center(
              child: Text(
                "© 2025 Flipkart Clone • All Rights Reserved",
                style: TextStyle(
                  fontSize: size.width * 0.03,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required String description,
    required Size size,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blue, size: size.width * 0.08),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: size.width * 0.045,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: size.width * 0.037,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
