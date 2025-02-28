// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:alkilate/services/services.dart';
import 'package:alkilate/views/login/login.dart';
import 'package:alkilate/shared/shared.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderScreen extends StatefulWidget {
  final Product product;

  const OrderScreen({super.key, required this.product});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  GoogleMapController? mapController;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    // Initialize marker for the product location
    if (widget.product.location != null) {
      _markers.add(
        Marker(
          markerId: MarkerId(widget.product.id),
          position: widget.product.location ?? const LatLng(0, 0),
          infoWindow: InfoWindow(
            title: widget.product.name,
            snippet: 'Pick up location',
          ),
        ),
      );
    }
  }

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
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product details section
            Text(
              'Product: ${widget.product.name}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Price: \$${widget.product.price}'),

            SizedBox(height: 20),
            Text(
              'Pickup Location:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),

            // Map showing the product location
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(106, 158, 158, 158),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: widget.product.location ?? const LatLng(0, 0),
                    zoom: 14,
                  ),
                  markers: _markers,
                  onMapCreated: (GoogleMapController controller) {
                    mapController = controller;
                  },
                ),
              ),
            ),

            SizedBox(height: 20),
            Text(
              'Coordinates: ${widget.product.location?.latitude.toStringAsFixed(6)}, ${widget.product.location?.longitude.toStringAsFixed(6)}',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),

            SizedBox(height: 20),

            // Checkout button
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                onPressed: () async {
                  Order order = Order(
                    product: widget.product.name,
                    productId: widget.product.id,
                    seller: widget.product.owner,
                    buyer: AuthService().user?.uid ?? '',
                    status: 'pending',
                    totalPrice: widget.product.price,
                    fromDate: widget.product.disponibleFrom,
                    untilDate: widget.product.disponibleTo,
                    productImage: widget.product.pictures[0],
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
                    final responseData = jsonDecode(response.body);
                    debugPrint('Order created: $responseData');

                    FirestoreService().addOrder(order);
                    FirestoreService().addOrderToUser(order);
                    FirestoreService().addOrderToSeller(order);
                    launchURL(context, jsonDecode(response.body));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to create order')),
                    );
                    throw Exception('Failed to create order');
                  }
                },
                child: Text('Proceed to Checkout'),
              ),
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
      Navigator.pushNamed(context, '/'); // Redirect to the desired screen
    });
  } catch (e) {
    debugPrint(e.toString());
  }
}
