import 'package:flutter/material.dart';
import 'package:gona_market_app/core/widgets/custom_snackbar.dart';
import 'package:gona_market_app/logic/providers/user_provider.dart';
import 'package:gona_market_app/presentation/routes/app_routes.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:gona_market_app/logic/providers/cart_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    print('user mehens $user');

    final cartItems = cartProvider.cartItems;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onPressed: () {
              cartProvider.clearCart();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: cartItems.isEmpty
                ? const Center(child: Text('Your cart is empty'))
                : ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];

                      return Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset:
                                  const Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16.0),
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey[200],
                            backgroundImage: NetworkImage(item.product.image),
                            child: ClipOval(
                              child: Image.network(
                                item.product.image,
                                fit: BoxFit.cover,
                                errorBuilder: (BuildContext context,
                                    Object error, StackTrace? stackTrace) {
                                  return Image.asset(
                                    'assets/images/placeholder.png',
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),
                          ),
                          title: Text(item.product.title),
                          subtitle: Text(NumberFormat.simpleCurrency(
                                  locale: 'en_NG', name: '₦')
                              .format(item.product.price)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () {
                                  if (item.quantity == 1) {
                                    CustomSnackbar.show(context,
                                        "You have only 1 quantity of '${item.product.title}' in your cart!");
                                    return;
                                  }
                                  cartProvider.removeItem(item.product);
                                },
                              ),
                              Text('${item.quantity}'),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () {
                                  int quantity = item.quantity;
                                  int qtyAvailable = int.tryParse(
                                          item.product.qtyAvailable ?? '0') ??
                                      0;

                                  if (quantity == qtyAvailable) {
                                    CustomSnackbar.show(context,
                                        "We only have the total of ${item.product.qtyAvailable} available in store for '${item.product.title}'");
                                    return;
                                  }

                                  cartProvider.addItem(item.product);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          CartSummary(user: user,),
        ],
      ),
    );
  }
}

class CartSummary extends StatelessWidget {
  final user;
  const CartSummary({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final total = cartProvider.totalPrice;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total: ${NumberFormat.simpleCurrency(locale: 'en_NG', name: '₦').format(total)}',
            // {NumberFormat.simpleCurrency(locale: 'en_NG', name: 'N')}

            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {
              // Add checkout logic here
              if (total == 0) {
                CustomSnackbar.show(context, ('No item in Cart Yet!'));
              }
              if (user == null) {
                CustomSnackbar.show(context, ('You have to login to perform this operation'));
              }

              Navigator.pushNamed(context, AppRoutes.checkout);
            },
            child:
                const Text('Checkout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
