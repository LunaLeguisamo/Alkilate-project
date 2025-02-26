import 'package:flutter/material.dart';
import 'package:alkilate/services/services.dart';

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
    return ListTile(
      title: Text(order.product),
      trailing: IconButton(
        icon: const Icon(Icons.check),
        onPressed: onAccept,
      ),
      leading: IconButton(
        icon: const Icon(Icons.cancel),
        onPressed: onCancel,
      ),
    );
  }
}
