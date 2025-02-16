import 'package:alkilate/views/home/home.dart';
import 'package:alkilate/views/login/login.dart';
import 'package:alkilate/views/products/product_filter/product_filter.dart';
import 'package:alkilate/views/products/product_search/product_search.dart';
import 'package:alkilate/views/profile/profile.dart';
import 'package:alkilate/views/products/add_product/add_product.dart';
import 'package:alkilate/views/profile/user_orders.dart';

var appRoutes = {
  '/': (context) => HomeScreen(),
  '/login': (context) => LoginScreen(),
  '/add-product': (context) => AddProductScreen(),
  '/product-filter': (context) => ProductFilterScreen(),
  '/product-search': (context) => ProductSearchScreen(),
  '/profile': (context) => ProfileScreen(),
  '/user-orders': (context) => UserOrdersScreen(),
};
