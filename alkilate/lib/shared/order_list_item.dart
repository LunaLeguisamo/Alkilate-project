import 'package:flutter/material.dart';
import 'package:alkilate/services/services.dart';
import 'package:intl/intl.dart'; // For date formatting

class OrderListItem extends StatelessWidget {
  final Order order;
  final VoidCallback onCancel;
  final VoidCallback onAccept;

  const OrderListItem({
    super.key,
    required this.order,
    required this.onCancel,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    // Format dates using the intl package
    final dateFormat =
        DateFormat('MMM dd, yyyy'); // Customize the format as needed
    final fromDate = dateFormat.format(order.fromDate);
    final untilDate = dateFormat.format(order.untilDate);

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
              borderRadius:
                  BorderRadius.circular(10), // Adjust the radius as needed
              child: Image.network(
                order.productImage,
                height: 89,
                width: 125,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                      Icons.error); // Error widget if image fails to load
                },
              ),
            ),
            const SizedBox(width: 10), // Spacing between image and text
            // Product Details
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.product,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                      height: 4), // Spacing between product name and price
                  Text(
                    'Total Price: \$${order.totalPrice.toStringAsFixed(2)}\nFrom: $fromDate \nUntil: $untilDate',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
            // Additional Column (if needed)
            Padding(
              padding: const EdgeInsets.all(17.0),
              child: Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.check, color: Color(0xFF2375D8)),
                    onPressed: onAccept,
                  ),
                  IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: onCancel,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
