import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('Login'),
              onPressed: () => Navigator.pushNamed(context, '/login'),
            ),
            SizedBox(height: 20), // Add some spacing between the buttons
            ElevatedButton(
              child: Text('Orders'),
              onPressed: () => Navigator.pushNamed(context, '/orders'),
            ),
            SizedBox(height: 20), // Add some spacing between the buttons
            ElevatedButton(
              child: Text('Product Detail'),
              onPressed: () => Navigator.pushNamed(context, '/product-detail'),
            ),
            SizedBox(height: 20), // Add some spacing between the buttons
            ElevatedButton(
              child: Text('Product Filter'),
              onPressed: () => Navigator.pushNamed(context, '/product-filter'),
            ),
            SizedBox(height: 20), // Add some spacing between the buttons
            ElevatedButton(
              child: Text('Product Search'),
              onPressed: () => Navigator.pushNamed(context, '/product-search'),
            ),
            SizedBox(height: 20), // Add some spacing between the buttons
            ElevatedButton(
              child: Text('Profile'),
              onPressed: () => Navigator.pushNamed(context, '/profile'),
            ),
          ],
        ),
      ),
    );
  }
}
