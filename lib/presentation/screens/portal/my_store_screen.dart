import 'package:flutter/material.dart';
import 'package:gona_market_app/core/widgets/custom_snackbar.dart';
import 'package:gona_market_app/logic/providers/my_product_provider.dart';
import 'package:gona_market_app/logic/providers/user_provider.dart';
import 'package:gona_market_app/presentation/routes/app_routes.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:gona_market_app/logic/providers/cart_provider.dart';

class MyStoreScreen extends StatefulWidget {
  const MyStoreScreen({super.key});

  @override
  State<MyStoreScreen> createState() => _MyStoreScreenState();
}

class _MyStoreScreenState extends State<MyStoreScreen> {
  @override
  Widget build(BuildContext context) {
    final myProductProvider = Provider.of<MyProductProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    final myProducts = myProductProvider.myProducts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Store'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add ,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.uploadProduct);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: myProducts.isEmpty
                ? const Center(child: Text('Your Store is empty'))
                : ListView.builder(
                    itemCount: myProducts.length,
                    itemBuilder: (context, index) {
                      final product = myProducts[index];

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
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16.0),
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey[200],
                            backgroundImage: NetworkImage(product.image),
                            child: ClipOval(
                              child: Image.network(
                                product.image,
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
                          title: Text(product.title),
                          subtitle: Text(NumberFormat.simpleCurrency(
                                  locale: 'en_NG', name: '₦')
                              .format(product.price)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () {
                                  // if (product.quantity == 1) {
                                  //   CustomSnackbar.show(context,
                                  //       "You have only 1 quantity of '${product.product.title}' in your cart!");
                                  //   return;
                                  // }
                                  // cartProvider.removeItem(product.product);
                                },
                              ),
                              // Text('${item.quantity}'),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () {
                                  // int quantity = item.quantity;
                                  // int qtyAvailable = int.tryParse(
                                  //         item.product.qtyAvailable ?? '0') ??
                                  //     0;

                                  // if (quantity == qtyAvailable) {
                                  //   CustomSnackbar.show(context,
                                  //       "We only have the total of ${item.product.qtyAvailable} available in store for '${item.product.title}'");
                                  //   return;
                                  // }

                                  // cartProvider.addItem(item.product);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
