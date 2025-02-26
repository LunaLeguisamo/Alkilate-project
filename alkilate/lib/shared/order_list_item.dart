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

    return Card(
      margin: const EdgeInsets.symmetric(
          vertical: 8.0, horizontal: 16.0), // Add margin for better spacing
      child: ListTile(
        minTileHeight: 120,
        minLeadingWidth: 80,
        title: Text(
          order.product,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Total Price: \$${order.totalPrice.toStringAsFixed(2)}\nFrom: $fromDate \nUntil: $untilDate',
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: SizedBox(
          width: 96,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.check, color: Color(0xFF2375D8)),
                onPressed: onAccept,
                padding: EdgeInsets.symmetric(vertical: 40),
                constraints: const BoxConstraints(), // Remove constraints
              ),
              IconButton(
                icon: const Icon(Icons.cancel),
                onPressed: onCancel,
                padding: EdgeInsets.symmetric(vertical: 40),
                constraints: const BoxConstraints(), // Remove constraints
              ),
            ],
          ),
        ),
        isThreeLine: true,
      ),
    );
  }
}
