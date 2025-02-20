import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:alkilate/services/services.dart';
import 'package:alkilate/views/login/login.dart';
import 'package:alkilate/shared/shared.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:http/http.dart' as http;

class OrderScreen extends StatefulWidget {
  final Product product;

  const OrderScreen({super.key, required this.product});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().userStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        } else if (snapshot.hasError) {
          return const ErrorMessage();
        } else if (snapshot.hasData) {
          return orderBuilder(context);
        } else {
          return const LoginScreen();
        }
      },
    );
  }

  orderBuilder(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                Order order = Order(
                  product: widget.product.name,
                  productId: widget.product.id,
                  seller: widget.product.owner,
                  buyer: AuthService().user?.uid ?? '',
                  status: 'pending',
                  totalPrice: widget.product.price,
                  dateCreated: DateTime.now(),
                  modifiedDate: DateTime.now(),
                );
                // Make an HTTP request to a specific URL
                final response = await http.post(
                  Uri.parse('https://app-p7vfglazhq-uc.a.run.app/checkout'),
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode(<String, dynamic>{
                    'item': widget.product.name,
                    'price': widget.product.price,
                    'id': order.id,
                    'seller': order.seller,
                    'user': order.buyer,
                  }),
                );
                if (response.statusCode == 200) {
                  // If the server returns a 200 OK response, parse the JSON
                  final responseData = jsonDecode(response.body);
                  debugPrint('Order created: $responseData');
                } else {
                  // If the server did not return a 200 OK response, throw an exception
                  throw Exception('Failed to create order');
                }
                FirestoreService().addOrder(order);
                FirestoreService().addOrderToUser(order);
                FirestoreService().addOrderToSeller(order);
                // ignore: use_build_context_synchronously
                launchURL(context, jsonDecode(response.body));
              },
              child: Text('Add Order'),
            ),
          ],
        ),
      ),
    );
  }
}

void launchURL(BuildContext context, url) async {
  try {
    await launchUrl(
      Uri.parse(url),
      customTabsOptions: CustomTabsOptions(
        colorSchemes: CustomTabsColorSchemes.defaults(
          toolbarColor: Theme.of(context).primaryColor,
        ),
        shareState: CustomTabsShareState.on,
        urlBarHidingEnabled: true,
        showTitle: true,
        closeButton: CustomTabsCloseButton(
          icon: 'close',
        ),
      ),
      safariVCOptions: SafariViewControllerOptions(
        preferredBarTintColor: Theme.of(context).primaryColor,
        preferredControlTintColor: Colors.white,
        barCollapsingEnabled: true,
        entersReaderIfAvailable: false,
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
      ),
    ).then((_) {
      // This callback is called when the browser is closed
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/'); // Redirect to the desired screen
    });
  } catch (e) {
    debugPrint(e.toString());
  }
}
