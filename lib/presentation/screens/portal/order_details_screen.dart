import 'package:flutter/material.dart';
import 'package:gona_market_app/core/utils/formatters.dart';
import 'package:gona_market_app/logic/providers/order_provider.dart';
import 'package:provider/provider.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) {
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
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      await orderProvider.fetchOrderDetails(widget.orderId);
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final order = orderProvider.selectedOrder;

    if (order == null) {
      return const Center(
          child: CircularProgressIndicator(
        color: Colors.red,
      ));
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Order Details',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary),
        ),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Card(
                elevation: 2,
                child: ListTile(
                  title: Row(
                    children: [
                      Text(
                        'Order: ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                      Text(order.paymentReference),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Status: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.secondary),
                          ),
                          Text(order.status),
                        ],
                      ),
                      // Text('Date: ${order.createdAt}'),
                      // Text('Status: ${order.status}'),
                      Row(
                        children: [
                          Text(
                            'Date & Time: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.secondary),
                          ),
                          Text(Formatters.formatDateTime(order.createdAt)),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Total: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.secondary),
                          ),
                          Text(
                              '${Formatters.formatCurrency(double.tryParse(order.amount) ?? 0)}'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Items',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              ...(order.items ?? []).map(
                (item) {
                  final product = item.product;
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: product != null && product.image.isNotEmpty
                          ? Image.network(product.image,
                              width: 50, height: 50, fit: BoxFit.cover)
                          : Icon(
                              Icons.image_not_supported,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      title: Text(
                        product!.title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      subtitle: Text('Qty: ${item.quantity}'),
                      trailing: Text(Formatters.formatCurrency(product.price)),
                    ),
                  );
                },
              ).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
