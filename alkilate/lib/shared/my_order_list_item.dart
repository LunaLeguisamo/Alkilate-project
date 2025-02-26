import 'package:flutter/material.dart';
import 'package:alkilate/services/services.dart';

class MyOrderListItem extends StatelessWidget {
  final Order order;

  const MyOrderListItem({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Container(
        padding: const EdgeInsets.all(9),
        height: 115,
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
                    '\$${order.totalPrice.toString()}',
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
              child: Text(
                order.status.toUpperCase(),
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFC89A02)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
