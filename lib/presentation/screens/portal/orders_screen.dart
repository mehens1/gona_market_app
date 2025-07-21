import 'package:flutter/material.dart';
import 'package:gona_market_app/core/utils/formatters.dart';
import 'package:gona_market_app/logic/providers/order_provider.dart';
import 'package:gona_market_app/logic/providers/user_provider.dart';
import 'package:gona_market_app/presentation/routes/app_routes.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool _isInit = true;
  bool _isLoading = false;

  late UserProvider userProvider;
  late dynamic user;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      userProvider = Provider.of<UserProvider>(context);
      user = userProvider.user;
      _isInit = false;
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        _isLoading = true;
      });
      final ordersProvider = Provider.of<OrderProvider>(context, listen: false);
      await ordersProvider.fetchOrders();
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final orders = orderProvider.orders;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Order History'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : orders.isEmpty
                ? const Center(child: Text('No orders available.'))
                : ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];

                      return Card(
                        color: Colors.green.shade50,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.orange.shade100,
                            child: Icon(Icons.shopping_bag,
                                color: Colors.orange.shade700),
                          ),
                          title: Row(
                            children: [
                              Text(
                                'Order No: ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ),
                              Text(
                                '#${order.id}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    'Date: ',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                  ),
                                  Text(Formatters.formatDateTime(
                                      order.createdAt)),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Total: ',
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary),
                                      ),
                                      Text(
                                        Formatters.formatCurrency(
                                            double.tryParse(
                                                    order.amount.toString()) ??
                                                0),
                                      ),
                                    ],
                                  ),

                                  // Text('Total: ₦${order.amount}'),
                                  Row(
                                    children: [
                                      Text(
                                        'Status: ',
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary),
                                      ),
                                      Text(order.status),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Reference: ',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                  ),
                                  Text(order.paymentReference),
                                ],
                              ),
                            ],
                          ),
                          trailing: Icon(Icons.arrow_forward_ios,
                              size: 16, color: Colors.grey),
                          onTap: () {
                            // Navigator.pushNamed(context, AppRoutes.order,
                            //     arguments: order.id);

                            Navigator.pushNamed(
                              context,
                              AppRoutes.order,
                              arguments: OrderScreenArguments(
                                  orderId: order.id.toString()),
                            );
                          },
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
