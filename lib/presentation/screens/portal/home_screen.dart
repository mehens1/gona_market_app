import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gona_market_app/core/widgets/text_inputs.dart';
import 'package:gona_market_app/data/models/product_model.dart';
import 'package:gona_market_app/data/repositories/user_repository.dart';
import 'package:gona_market_app/logic/providers/product_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserRepository _userRepository = GetIt.instance<UserRepository>();
  TextEditingController searchInputController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final productProvider =
          Provider.of<ProductProvider>(context, listen: false);
      productProvider.fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 150,
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 0,
        title: Text(
          'Your Daily\nFood Market',
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 38,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.account_circle,
              color: Theme.of(context).colorScheme.primary,
              size: 50,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryTab('All', true),
                  _buildCategoryTab('Fruits', false),
                  _buildCategoryTab('Grains', false),
                  _buildCategoryTab('Vegetables', false),
                  _buildCategoryTab('Perishable', false),
                  _buildCategoryTab('Calories', false),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: PrimaryTextInput(
              labelText: "Search...",
              obscureText: false,
              controller: searchInputController,
              keyboardType: TextInputType.text,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: Consumer<ProductProvider>(
                builder: (context, productProvider, child) {
                  if (productProvider.products.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 3 / 4,
                    ),
                    itemCount: productProvider.products.length,
                    itemBuilder: (context, index) {
                      final product = productProvider.products[index];
                      return _buildProductCard(product);
                    },
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCategoryTab(String title, bool isSelected) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: isSelected
            ? Theme.of(context).colorScheme.onPrimary
            : Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(ProductModel product) {
    final formatCurrency = NumberFormat.currency(locale: 'en_US', symbol: '₦');

    return Container(
      decoration: BoxDecoration(color: Colors.grey[100]),
      width: 150,
      height: 500,
      child: Column(
        children: [
          Flexible(
            flex: 5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/images/product_placeholder.png',
                image: product.image,
                fit: BoxFit.cover,
                height: 150,
                width: double.infinity,
                imageErrorBuilder: (context, error, stackTrace) {
                  return Image.asset('assets/images/product_placeholder.png');
                },
              ),
            ),
          ),
          const SizedBox(
            height: 14,
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                product.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
      
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                formatCurrency.format(product.price),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 18,
                ),
              ),
            ),
          ),
      
          if (product.guage != null)
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 10,
              ),
              child: Text(
                'Per: ${product.guage!.name}',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
