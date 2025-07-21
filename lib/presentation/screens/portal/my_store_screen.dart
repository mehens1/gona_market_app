import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gona_market_app/logic/providers/my_product_provider.dart';
import 'package:gona_market_app/presentation/routes/app_routes.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MyStoreScreen extends StatefulWidget {
  const MyStoreScreen({super.key});

  @override
  State<MyStoreScreen> createState() => _MyStoreScreenState();
}

class _MyStoreScreenState extends State<MyStoreScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final myProductProvider =
          Provider.of<MyProductProvider>(context, listen: false);
      myProductProvider.fetchMyProducts();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              Icons.add,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.uploadProduct);
            },
          ),
        ],
      ),
      body: Consumer<MyProductProvider>(
        builder: (context, myProductProvider, child) {
          if (myProductProvider.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          var myProducts = myProductProvider.myProducts;

          if (myProducts.isEmpty) {
            return Center(
              child: Image.asset('assets/images/no-product.png'),
            );
          }

          return ListView.builder(
            itemCount: myProducts.length,
            itemBuilder: (context, index) {
              final product = myProducts[index];
              return Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  color: product.status == "1"
                      ? Colors.green[50]
                      : product.status == "0"
                          ? Colors.amber[50]
                          : Colors.red[50],
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
                  contentPadding: const EdgeInsets.all(14.0),
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    backgroundImage: NetworkImage(product.image),
                    child: ClipOval(
                      child: Image.network(
                        product.image,
                        fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object error,
                            StackTrace? stackTrace) {
                          return Image.asset(
                            'assets/images/placeholder.png',
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  ),
                  title: Text(product.title),
                  subtitle: Text(
                      NumberFormat.simpleCurrency(locale: 'en_NG', name: '₦')
                          .format(product.price)),
                  trailing: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            onPressed: () {
                              if (kDebugMode) {
                                print("product to delete: $product");
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
