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
  User? user;

  @override
  void initState() {
    super.initState();
    _orders = widget.orders;
    _fetchCurrentUser();
  }

  Future<void> _fetchCurrentUser() async {
    try {
      var currentUser = await FirestoreService().getCurrentUser();
      setState(() {
        user = currentUser;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to fetch user: $e'),
        ),
      );
    }
  }

  Future<void> _refreshOrders() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var updatedOrders = await FirestoreService().getListings();
      setState(() {
        _orders = updatedOrders;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Orders refreshed successfully'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to refresh orders: $e'),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _showConfirmationDialog(
      BuildContext context, String message, VoidCallback onConfirm) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar acción'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/pending-illustration.png'),
            fit: BoxFit.fitWidth,
            alignment: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (user != null)
              ProfileBanner(
                  user: user!), // Display banner only if user is not null
            Padding(
              padding: const EdgeInsets.all(22),
              child: Text(
                'Incoming orders',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshOrders,
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _orders.isEmpty
                        ? const Center(child: Text('No orders available'))
                        : ListView.separated(
                            itemCount: _orders.length,
                            separatorBuilder: (context, index) =>
                                const Divider(color: Colors.transparent),
                            itemBuilder: (context, index) {
                              var order = _orders[index];
                              return OrderListItem(
                                order: order,
                                onCancel: () async {
                                  await _showConfirmationDialog(
                                    context,
                                    '¿Estás seguro de que deseas cancelar este pedido?',
                                    () async {
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      try {
                                        await FirestoreService()
                                            .cancelOrder(order.id);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text('Pedido cancelado'),
                                          ),
                                        );
                                        setState(() {
                                          _orders.removeAt(index);
                                        });
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
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
                                onAccept: () async {
                                  await _showConfirmationDialog(
                                    context,
                                    '¿Estás seguro de que deseas aceptar este pedido?',
                                    () async {
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      try {
                                        await FirestoreService()
                                            .acceptOrder(order.id, order.buyer);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text('Pedido aceptado'),
                                          ),
                                        );
                                        setState(() {
                                          _orders.removeAt(index);
                                        });
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
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
                              );
                            },
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
