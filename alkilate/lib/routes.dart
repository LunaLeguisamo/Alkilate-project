import 'package:alkilate/views/home/home.dart';
import 'package:alkilate/views/login/login.dart';
import 'package:alkilate/views/products/product_search/product_search.dart';
import 'package:alkilate/views/profile/profile.dart';
import 'package:alkilate/views/products/add_product/add_product.dart';
import 'package:alkilate/views/profile/user_orders.dart';
import 'package:alkilate/views/profile/user_products.dart';
import 'package:alkilate/views/profile/pending.dart';
import 'package:alkilate/shared/calendar.dart';

var appRoutes = {
  '/': (context) => HomeScreen(),
  '/login': (context) => LoginScreen(),
  '/add-product': (context) => AddProductScreen(),
  '/product-search': (context) => ProductSearchScreen(),
  '/profile': (context) => ProfileScreen(),
  '/user-orders': (context) => UserOrdersScreen(),
  '/user-products': (context) => UserProductsScreen(),
  '/pending': (context) => UserPendingScreen(),
  '/calendar': (context) => CalendarAvailabilityWidget(),
};
