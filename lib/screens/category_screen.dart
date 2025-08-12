import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final List<Map<String, dynamic>> categories = [
    {"name": "Mobiles", "imageUrl": "https://via.placeholder.com/60"},
    {"name": "Fashion", "imageUrl": "https://via.placeholder.com/60"},
    {"name": "Electronics", "imageUrl": "https://via.placeholder.com/60"},
    {"name": "Home", "imageUrl": "https://via.placeholder.com/60"},
    {"name": "Toys", "imageUrl": "https://via.placeholder.com/60"},
    {"name": "Sports", "imageUrl": "https://via.placeholder.com/60"},
    {"name": "Furniture", "imageUrl": "https://via.placeholder.com/60"},
    {"name": "Bikes & Scooters", "imageUrl": "https://via.placeholder.com/60"},
  ];

  final Map<String, List<Map<String, String>>> products = {
    "Mobiles": [
      {"title": "iPhone 15", "imageUrl": "https://via.placeholder.com/150"},
      {"title": "Samsung S24", "imageUrl": "https://via.placeholder.com/150"},
    ],
    "Fashion": [
      {"title": "T-Shirt", "imageUrl": "https://via.placeholder.com/150"},
      {"title": "Jeans", "imageUrl": "https://via.placeholder.com/150"},
    ],
    "Electronics": [
      {"title": "Laptop", "imageUrl": "https://via.placeholder.com/150"},
      {"title": "Smart Watch", "imageUrl": "https://via.placeholder.com/150"},
    ],
    "Home": [
      {"title": "Sofa", "imageUrl": "https://via.placeholder.com/150"},
      {"title": "Lamp", "imageUrl": "https://via.placeholder.com/150"},
    ],
    "Toys": [
      {"title": "Lego Set", "imageUrl": "https://via.placeholder.com/150"},
      {"title": "Teddy Bear", "imageUrl": "https://via.placeholder.com/150"},
    ],
    "Sports": [
      {"title": "Cricket Bat", "imageUrl": "https://via.placeholder.com/150"},
      {"title": "Football", "imageUrl": "https://via.placeholder.com/150"},
    ],
    "Furniture": [
      {"title": "Dining Table", "imageUrl": "https://via.placeholder.com/150"},
      {"title": "Chair", "imageUrl": "https://via.placeholder.com/150"},
    ],
    "Bikes & Scooters": [
      {
        "title": "Electric Scooter",
        "imageUrl": "https://via.placeholder.com/150",
      },
      {"title": "Mountain Bike", "imageUrl": "https://via.placeholder.com/150"},
    ],
  };

  String selectedCategory = "Mobiles";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  hintText: "Search for products",
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            Expanded(
              child: Row(
                children: [
                  // Left side category list
                  Container(
                    width: 100,
                    color: Colors.white,
                    child: ListView.builder(
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        final isSelected = category["name"] == selectedCategory;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCategory = category["name"];
                            });
                          },
                          child: Container(
                            color: isSelected
                                ? Colors.blue[50]
                                : Colors.transparent,
                            child: Row(
                              children: [
                                // Blue highlight bar
                                Container(
                                  width: 5,
                                  height: 70,
                                  color: isSelected
                                      ? Colors.blue
                                      : Colors.transparent,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      children: [
                                        CircleAvatar(
                                          radius: 25,
                                          backgroundColor: Colors.grey[200],
                                          child: Image.network(
                                            category["imageUrl"]!,
                                            width: 30,
                                            height: 30,
                                            fit: BoxFit.contain,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    const Icon(
                                                      Icons.image_not_supported,
                                                    ),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          category["name"]!,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Right side products grid
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(8),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                      itemCount: products[selectedCategory]?.length ?? 0,
                      itemBuilder: (context, index) {
                        print(
                          "item count: ${products[selectedCategory]?.length}",
                        );
                        final product = products[selectedCategory]![index];
                        return Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12),
                                  ),
                                  child: Image.network(
                                    product["imageUrl"]!,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                              Icons.broken_image,
                                              size: 80,
                                            ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  product["title"]!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
