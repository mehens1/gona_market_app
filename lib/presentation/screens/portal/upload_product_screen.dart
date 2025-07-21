import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gona_market_app/core/widgets/button.dart';
import 'package:gona_market_app/core/widgets/custom_snackbar.dart';
import 'package:gona_market_app/core/widgets/dropdown.dart';
import 'package:gona_market_app/core/widgets/text_inputs.dart';
import 'package:gona_market_app/data/services/api_service.dart';
import 'package:gona_market_app/data/services/product_upload_service.dart';
import 'package:gona_market_app/logic/providers/categories_provider.dart';
import 'package:gona_market_app/logic/providers/guage_provider.dart';
import 'package:gona_market_app/logic/providers/my_product_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProductUploadScreen extends StatefulWidget {
  const ProductUploadScreen({super.key});

  @override
  State<ProductUploadScreen> createState() => _ProductUploadScreenState();
}

class _ProductUploadScreenState extends State<ProductUploadScreen> {
  late Dio _dio;
  late ApiService _apiService;
  late ProductUploadService _productUploadService;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _selectedCategory;
  String? _selectedGauge;
  XFile? _productImage;

  bool _isLoading = false;
  bool _isPickingImage = false;

  Future<void> _pickImage() async {
    if (_isPickingImage) return;
    setState(() {
      _isPickingImage = true;
    });

    final ImagePicker picker = ImagePicker();
    final XFile? image = await showDialog<XFile?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          actions: [
            TextButton(
              onPressed: () async {
                final image =
                    await picker.pickImage(source: ImageSource.gallery);
                Navigator.pop(context, image);
              },
              child: const Text('Gallery'),
            ),
            TextButton(
              onPressed: () async {
                final image =
                    await picker.pickImage(source: ImageSource.camera);
                Navigator.pop(context, image);
              },
              child: const Text('Camera'),
            ),
          ],
        );
      },
    );

    if (image != null) {
      setState(() {
        _productImage = image;
      });
    }

    setState(() {
      _isPickingImage = false;
    });
  }

  Future<void> _submitProduct() async {
    if (!_formKey.currentState!.validate()) {
      CustomSnackbar.show(context, 'Please fill in all fields correctly');
      return;
    }

    if (_productImage == null ||
        _selectedCategory == null ||
        _selectedGauge == null) {
      CustomSnackbar.show(context, 'Please fill in all fields');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final formData = FormData.fromMap({
      'product_image': await MultipartFile.fromFile(
        _productImage!.path,
        filename: 'product_image.jpg',
      ),
      'product_name': _titleController.text,
      'product_price': _priceController.text,
      'product_quantity': _quantityController.text,
      'description': _descriptionController.text,
      'product_category': _selectedCategory,
      'product_guage': _selectedGauge,
    });

    try {
      final response = await _productUploadService.uploadProduct(formData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final myProductProvider =
            Provider.of<MyProductProvider>(context, listen: false);
        myProductProvider.fetchMyProducts();
        CustomSnackbar.show(context, 'Product uploaded successfully!');
        Navigator.pop(context);
      } else {
        CustomSnackbar.show(context, 'Failed to upload product!');
      }
    } catch (error) {
      CustomSnackbar.show(context, 'Error uploading product: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _dio = Dio();
    _apiService = ApiService(_dio, baseUrl: dotenv.env['API_URL'] ?? '');
    _productUploadService = ProductUploadService(_apiService);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final guageProvider = Provider.of<GuageProvider>(context, listen: false);
      final categoryProvider =
          Provider.of<CategoryProvider>(context, listen: false);

      guageProvider.fetchGuages();
      categoryProvider.fetchCategories();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final guageProvider = Provider.of<GuageProvider>(context);

    if (categoryProvider.isLoading || guageProvider.isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          "Upload Product",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12.0),
                    image: _productImage != null
                        ? DecorationImage(
                            image: FileImage(File(_productImage!.path)),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _productImage == null
                      ? const Center(
                          child: Text(
                            "Tap to upload image",
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 16.0),
              PrimaryTextInput(
                labelText: "Product Title",
                controller: _titleController,
                keyboardType: TextInputType.text,
                validator: (value) =>
                    validateRequiredField(value, "Product Title"),
              ),
              const SizedBox(height: 16.0),
              PrimaryTextInput(
                labelText: "Price",
                controller: _priceController,
                keyboardType: TextInputType.number,
                validator: (value) =>
                    validateRequiredField(value, "Product Price"),
              ),
              const SizedBox(height: 16.0),
              PrimaryDropdown(
                value: _selectedCategory,
                hintText: "Select Category",
                items: categoryProvider.categories
                    .map(
                      (category) => category['category'].toString(),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value!.isNotEmpty) {
                    setState(() {
                      final categoryObj = categoryProvider.categories
                          .firstWhere(
                              (category) => category['category'] == value);
                      _selectedCategory = categoryObj['id'];
                    });
                  }
                },
              ),
              const SizedBox(height: 16.0),
              PrimaryDropdown(
                value: _selectedGauge,
                hintText: "Select Measure/Guage",
                items: guageProvider.guages
                    .map(
                      (guage) => guage['guage'].toString(),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value!.isNotEmpty) {
                    setState(() {
                      final guageObj = guageProvider.guages
                          .firstWhere((guage) => guage['guage'] == value);
                      _selectedGauge = guageObj['id'];
                    });
                  }
                },
              ),
              const SizedBox(height: 16.0),
              PrimaryTextInput(
                labelText: "Quantity Avilable",
                controller: _quantityController,
                keyboardType: TextInputType.number,
                validator: (value) =>
                    validateRequiredField(value, "Product Quantity"),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24.0),
              PrimaryButton(
                text: _isLoading ? "Uploading Product..." : "Submit Product",
                onPressed: _isLoading ? () {} : _submitProduct,
              )
            ],
          ),
        ),
      ),
    );
  }

  String? validateRequiredField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required!';
    }
    return null;
  }
}
