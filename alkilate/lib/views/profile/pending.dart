// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:alkilate/services/services.dart';
import 'package:alkilate/shared/shared.dart';

class UserPendingScreen extends StatefulWidget {
  const UserPendingScreen({super.key});

  @override
  UserPendingScreenState createState() => UserPendingScreenState();
}

class UserPendingScreenState extends State<UserPendingScreen> {
  Future<List<Order>> _fetchOrders() async {
    return FirestoreService().getListings();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Order>>(
      future: _fetchOrders(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        } else if (snapshot.hasError) {
          return Center(
            child: ErrorMessage(message: snapshot.error.toString()),
          );
        } else if (snapshot.hasData) {
          var orders = snapshot.data!;
          if (orders.isEmpty) {
            return const Center(
              child: Text('No orders found for this user'),
            );
          }
          return OrderListScreen(orders: orders);
        } else {
          return const Center(
            child: Text('No orders found for this user'),
          );
        }
      },
    );
  }
}

class OrderListScreen extends StatefulWidget {
  final List<Order> orders;

  const OrderListScreen({super.key, required this.orders});

  @override
  OrderListScreenState createState() => OrderListScreenState();
}

class OrderListScreenState extends State<OrderListScreen> {
  late List<Order> _orders;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _orders = widget.orders;
  }

  Future<void> _refreshOrders() async {
    setState(() {
      _isLoading = true;
    });
    var updatedOrders = await FirestoreService().getListings();
    setState(() {
      _orders = updatedOrders;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Incoming Orders'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshOrders,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _orders.isEmpty
                ? const Center(child: Text('No orders available'))
                : ListView.builder(
                    itemCount: _orders.length,
                    itemBuilder: (context, index) {
                      var order = _orders[index];
                      return OrderListItem(
                        order: order,
                        onCancel: () async {
                          setState(() {
                            _isLoading = true;
                          });
                          try {
                            await FirestoreService().cancelOrder(order.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Pedido cancelado'),
                              ),
                            );
                            setState(() {
                              _orders.removeAt(index);
                            });
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error: $e'),
                              ),
                            );
                          } finally {
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        },
                        onAccept: () async {
                          setState(() {
                            _isLoading = true;
                          });
                          try {
                            await FirestoreService()
                                .acceptOrder(order.id, order.buyer);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Pedido aceptado'),
                              ),
                            );
                            setState(() {
                              _orders.removeAt(index);
                            });
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error: $e'),
                              ),
                            );
                          } finally {
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        },
                      );
                    },
                  ),
      ),
    );
  }
}

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
