import 'package:flipkart_clone/widget/appbar.dart';
import 'package:flipkart_clone/widget/categorybar.dart';
import 'package:flutter/material.dart';
import '../../../widget/appbar.dart'; // your AppBar code

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildFlipkartAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 15,
              ),
              child: Text(
                "Top Categories",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 16),
            CategoryBar(),
            Divider(),
            SizedBox(height: 400),
          ],
        ),
      ),
    );
  }
}
