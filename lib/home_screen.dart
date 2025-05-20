import 'package:flutter/material.dart';
import 'bathroom_essentials_screen.dart';
import 'kitchenware.dart';
import 'cleaning_tools.dart';
import 'sanitary_items.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plastic Mart'),
        backgroundColor: Colors.teal,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildCategoryCard(
            context,
            'Bathroom Essentials',
            Icons.bathtub,
            Colors.blue,
            const BathroomEssentialsScreen(),
          ),
          _buildCategoryCard(
            context,
            'Kitchenware',
            Icons.kitchen,
            Colors.orange,
            const Kitchenware(),
          ),
          _buildCategoryCard(
            context,
            'Cleaning Tools',
            Icons.cleaning_services,
            Colors.green,
            const CleaningTools(),
          ),
          _buildCategoryCard(
            context,
            'Sanitary Items',
            Icons.home,
            Colors.purple,
            const SanitaryItems(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    Widget screen,
  ) {
    return Card(
      elevation: 5,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color.withOpacity(0.7), color],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: Colors.white),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
