import 'package:flutter/material.dart';
import 'package:alkilate/services/services.dart';
import 'package:alkilate/views/login/login.dart';
import 'package:alkilate/shared/shared.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

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
              onPressed: () {
                Order order = Order(
                  product: widget.product.id,
                  seller: widget.product.owner,
                  buyer: AuthService().user?.uid ?? '',
                  status: 'pending',
                  totalPrice: widget.product.price,
                  dateCreated: DateTime.now(),
                  modifiedDate: DateTime.now(),
                );
                launchURL(context);
                FirestoreService().addOrder(order);
              },
              child: Text('Add Order'),
            ),
          ],
        ),
      ),
    );
  }
}

void launchURL(BuildContext context) async {
  try {
    await launchUrl(
      Uri.parse('https://flutter.dev'),
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
      Navigator.pushNamed(context, '/'); // Redirect to the desired screen
    });
  } catch (e) {
    debugPrint(e.toString());
  }
}
