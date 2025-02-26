// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:alkilate/services/services.dart';

class MyProductsListItem extends StatefulWidget {
  final Product product;

  const MyProductsListItem({
    super.key,
    required this.product,
  });

  @override
  State<MyProductsListItem> createState() => _MyProductsListItemState();
}

class _MyProductsListItemState extends State<MyProductsListItem> {
  late Product _product;

  @override
  void initState() {
    super.initState();
    _product = widget.product; // Initialize with the passed product
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Container(
        padding: const EdgeInsets.all(9),
        height: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(20, 0, 0, 0),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            // Product Image with Rounded Borders
            ClipRRect(
              borderRadius: BorderRadius.circular(10), // Rounded corners
              child: Image.network(
                _product.pictures[0],
                height: 110,
                width: 150,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.error,
                    size: 50,
                    color: Colors.grey,
                  ); // Error widget if image fails to load
                },
              ),
            ),
            const SizedBox(width: 10), // Spacing between image and text
            // Product Details
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  _buildStatusText(context), // Status text
                  const SizedBox(height: 8),
                  Text(
                    _product.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                      height: 4), // Spacing between product name and price
                  Text(
                    '\$${_product.price.toString()}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
            // Action Buttons
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!_product.rejected && _product.approved)
                    IconButton(
                      tooltip: 'Toggle Availability',
                      icon: const Icon(Icons.swap_horiz),
                      onPressed: () async {
                        try {
                          await FirestoreService()
                              .toggleProductAvailability(_product.id);
                          setState(() {
                            // Update the local state to reflect the new availability
                            _product.availability = !_product.availability;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(_product.availability
                                  ? 'Marked as available'
                                  : 'Marked as not available'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('Failed to toggle availability: $e'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                    ),
                  IconButton(
                    tooltip: 'Delete Product',
                    onPressed: () async {
                      try {
                        await FirestoreService().deleteProduct(_product.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Product deleted successfully'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to delete product: $e'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build status text
  Widget _buildStatusText(BuildContext context) {
    if (_product.approved) {
      return Text(
        _product.availability ? 'Available for rent' : 'In use',
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: Color(0xFF719F3D),
        ),
      );
    } else if (_product.rejected) {
      return TextButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Reason'),
                content: Text(_product.message),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Close'),
                  ),
                ],
              );
            },
          );
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(
              color: Color(0xFFBD5839),
              width: 1,
            ),
          ),
          elevation: 0,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: const Text(
          'Rejected',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFFBD5839),
          ),
        ),
      );
    } else {
      return Text(
        'Pending for approval',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: Color(0xFFC89A02),
        ),
      );
    }
  }
}
