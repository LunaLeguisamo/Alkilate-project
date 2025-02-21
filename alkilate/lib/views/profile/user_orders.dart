import 'package:flutter/material.dart';
import 'package:alkilate/services/services.dart';
import 'package:alkilate/shared/shared.dart';

class UserOrdersScreen extends StatefulWidget {
  const UserOrdersScreen({super.key});
  @override
  UserOrdersScreenState createState() => UserOrdersScreenState();
}

class UserOrdersScreenState extends State<UserOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Order>>(
      future: FirestoreService().getOrderList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        } else if (snapshot.hasError) {
          return Center(
            child: ErrorMessage(message: snapshot.error.toString()),
          );
        } else if (snapshot.hasData) {
          var orders = snapshot.data!;
          return listBuilder(orders);
        } else {
          return const Text('No orders found for this user');
        }
      },
    );
  }

  Widget listBuilder(List<Order> orders) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My orders'),
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          var order = orders[index];
          return ListTile(
            title: Text(order.product),
            subtitle: Text(order.totalPrice.toString()),
            trailing: Text(order.status),
            // cancel order
            leading: IconButton(
              icon: const Icon(Icons.cancel),
              onPressed: () {
                FirestoreService().cancelOrder(order.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pedido cancelado'),
                  ),
                );
                // refresh the list
                setState(() {});
              },
            ),
          );
        },
      ),
    );
  }
}
