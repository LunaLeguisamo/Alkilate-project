// ignore_for_file: use_build_context_synchronously

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
          return ProductsListScreen(products: products);
        } else {
          return Center(
            child: ErrorMessage(message: 'No products found for this user'),
          );
        }
      },
    );
  }
}

class ProductsListScreen extends StatefulWidget {
  final List<Product> products;

  const ProductsListScreen({super.key, required this.products});

  @override
  ProductsListScreenState createState() => ProductsListScreenState();
}

class ProductsListScreenState extends State<ProductsListScreen> {
  late List<Product> _products;
  bool _isLoading = false;
  User? user;

  @override
  void initState() {
    super.initState();
    _products = widget.products;
    _fetchCurrentUser();
  }

  Future<void> _fetchCurrentUser() async {
    try {
      var currentUser = await FirestoreService().getCurrentUser();
      setState(() {
        user = currentUser;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to fetch user: $e'),
        ),
      );
    }
  }

  Future<void> _refreshProducts() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var updatedProducts = await FirestoreService().getUserProductsList();
      setState(() {
        _products = updatedProducts;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Products refreshed successfully'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to refresh products: $e'),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/product-illustration.png'),
            fit: BoxFit.fitWidth,
            alignment: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (user != null)
              ProfileBanner(
                  user: user!), // Display banner only if user is not null
            Padding(
              padding: const EdgeInsets.all(22),
              child: Text(
                'My Products',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshProducts,
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _products.isEmpty
                        ? const Center(child: Text('No products available'))
                        : ListView.separated(
                            itemCount: _products.length,
                            separatorBuilder: (context, index) =>
                                const Divider(color: Colors.transparent),
                            itemBuilder: (context, index) {
                              var product = _products[index];
                              return MyProductsListItem(product: product);
                            },
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
