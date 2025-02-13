import 'package:alkilate/views/home/home.dart';
import 'package:alkilate/views/login/login.dart';
import 'package:alkilate/views/orders/orders.dart';
import 'package:alkilate/views/products/product_filter/product_filter.dart';
import 'package:alkilate/views/products/product_search/product_search.dart';
import 'package:alkilate/views/profile/profile.dart';

var appRoutes = {
  '/': (context) => HomeScreen(),
  '/login': (context) => LoginScreen(),
  '/orders': (context) => OrderScreen(),
  '/product-filter': (context) => ProductFilterScreen(),
  '/product-search': (context) => ProductSearchScreen(),
  '/profile': (context) => ProfileScreen(),
};
