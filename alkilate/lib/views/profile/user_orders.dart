// ignore_for_file: use_build_context_synchronously

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
          return OrderListScreen(orders: orders);
        } else {
          return const Text('No orders found for this user');
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
      var updatedOrders = await FirestoreService().getOrderList();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/order-illustration.png'),
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
                'My orders',
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
                              return MyOrderListItem(order: order);
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
