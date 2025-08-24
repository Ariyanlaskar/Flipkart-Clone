import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Help & Support"),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search for help...",
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          fontSize: size.width * 0.038,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "Common Issues",
              style: TextStyle(
                fontSize: size.width * 0.045,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildIssueTile(
              "Order not delivered",
              Icons.local_shipping_outlined,
              size,
            ),
            _buildIssueTile("Return / Exchange", Icons.refresh_outlined, size),
            _buildIssueTile(
              "Payment & Refund",
              Icons.account_balance_wallet_outlined,
              size,
            ),
            _buildIssueTile(
              "Offers & Discounts",
              Icons.local_offer_outlined,
              size,
            ),

            const SizedBox(height: 20),

            Text(
              "Frequently Asked Questions",
              style: TextStyle(
                fontSize: size.width * 0.045,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildFaq(
              "How do I track my order?",
              "Go to 'My Orders' → Select your order → Tap 'Track'.",
              size,
            ),
            _buildFaq(
              "How can I cancel an order?",
              "Go to 'My Orders' → Select your order → Tap 'Cancel'.",
              size,
            ),
            _buildFaq(
              "What payment methods are accepted?",
              "We support UPI, Cards, Netbanking, Wallets, and COD.",
              size,
            ),

            const SizedBox(height: 20),

            Text(
              "Need More Help?",
              style: TextStyle(
                fontSize: size.width * 0.045,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildContactTile(
              "Email Us",
              "ariyanlaskar2002@gmail.com",
              Icons.email_outlined,
              size,
            ),
            _buildContactTile(
              "Call Us",
              "+91 7002508034",
              Icons.call_outlined,
              size,
            ),
            _buildContactTile(
              "Chat with Support",
              "Get instant help from our team",
              Icons.chat_bubble_outline,
              size,
            ),

            const SizedBox(height: 40),

            Center(
              child: Text(
                "© 2025 Flipkart Clone • Support Team",
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

  Widget _buildIssueTile(String title, IconData icon, Size size) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue, size: size.width * 0.07),
        title: Text(title, style: TextStyle(fontSize: size.width * 0.04)),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: () {},
      ),
    );
  }

  Widget _buildFaq(String question, String answer, Size size) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ExpansionTile(
        iconColor: Colors.blue,
        collapsedIconColor: Colors.grey,
        title: Text(
          question,
          style: TextStyle(
            fontSize: size.width * 0.04,
            fontWeight: FontWeight.w500,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              answer,
              style: TextStyle(
                fontSize: size.width * 0.038,
                height: 1.4,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactTile(
    String title,
    String subtitle,
    IconData icon,
    Size size,
  ) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue, size: size.width * 0.07),
        title: Text(title, style: TextStyle(fontSize: size.width * 0.04)),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: size.width * 0.035,
            color: Colors.grey[700],
          ),
        ),
        onTap: () {},
      ),
    );
  }
}
