import 'package:flutter/material.dart';
import 'package:gona_market_app/core/widgets/custom_snackbar.dart';
import 'package:gona_market_app/data/models/product_model.dart';
import 'package:gona_market_app/logic/providers/cart_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late ProductModel product;
  @override
  void initState() {
    super.initState();
    product = widget.product;
  }

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(locale: 'en_US', symbol: '₦');
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.favorite,
              color: Colors.red,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.network(
                    product.image,
                    height: 300,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              product.title,
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                  color: Colors.red,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50))),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.favorite,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  CustomSnackbar.show(context,
                                      'You have just liked \'${product.title}\'');
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.star,
                                color: Theme.of(context).colorScheme.secondary),
                            Icon(Icons.star,
                                color: Theme.of(context).colorScheme.secondary),
                            Icon(Icons.star,
                                color: Theme.of(context).colorScheme.secondary),
                            Icon(Icons.star,
                                color: Theme.of(context).colorScheme.secondary),
                            Icon(Icons.star_border,
                                color: Theme.of(context).colorScheme.secondary),
                          ],
                        ),
                        if (product.qtyAvailable != null) ...[
                          const SizedBox(height: 16),
                          const Text('Qty. Available:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Row(
                            children: [
                              Text(product.qtyAvailable.toString()),
                              if (product.guage != null)
                                Text(' ${product.guage!.name}'),
                            ],
                          ),
                        ],
                        if (product.category != null) ...[
                          const SizedBox(height: 16),
                          const Text('Category:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(product.category!.category.toString()),
                        ],
                        ...[
                          const SizedBox(height: 16),
                          Text(
                            'Description:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary),
                          ),
                          Text(
                            product.description,
                            textAlign: TextAlign.justify,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
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
                  formatCurrency.format(product.price),
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    final cartProvider = context.read<CartProvider>();
                    cartProvider.addItem(product);
                    CustomSnackbar.show(
                        context, '${product.title} added to cart!');
                  },
                  child: const Text(
                    'Add to Cart',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _colorChip(BuildContext context, Color color) {
    return Chip(
      label: Container(width: 20, height: 20, color: color),
      backgroundColor: Colors.grey[200],
    );
  }
}
