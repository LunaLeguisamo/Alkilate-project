import 'package:flutter/material.dart';
import 'package:alkilate/services/services.dart';
import 'package:alkilate/shared/shared.dart';

class UserProductsScreen extends StatefulWidget {
  const UserProductsScreen({super.key});
  @override
  UserProductsScreenState createState() => UserProductsScreenState();
}

class UserProductsScreenState extends State<UserProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: FirestoreService().getUserProductsList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        } else if (snapshot.hasError) {
          return Center(
            child: ErrorMessage(message: snapshot.error.toString()),
          );
        } else if (snapshot.hasData) {
          var products = snapshot.data!;
          return listBuilder(products);
        } else {
          return const Text('No products found for this user');
        }
      },
    );
  }

  Widget listBuilder(List<Product> products) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My products'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          var product = products[index];
          return ListTile(
            title: Text(product.name),
            subtitle: product.approved
                ? Text(product.availability ? 'available' : 'not available')
                : product.rejected
                    ? Text('product rejected')
                    : const Text('pending for approval'),
            trailing: product.approved
                ? Text('Approved')
                : product.rejected
                    ? Text(product.message)
                    : Text('Pending'),
            leading: product.rejected || !product.approved
                ? const Text('')
                : IconButton(
                    icon: const Icon(Icons.swap_horiz),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(product.availability
                              ? 'not available'
                              : 'available'),
                        ),
                      );
                      // refresh the list
                      setState(() {});
                    },
                  ),
          );
        },
      ),
    );
  }
}
