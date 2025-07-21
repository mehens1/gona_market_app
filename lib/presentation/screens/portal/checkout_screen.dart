import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gona_market_app/core/utils/loadingModal.dart';
import 'package:gona_market_app/core/widgets/button.dart';
import 'package:gona_market_app/core/widgets/secondary_button.dart';
import 'package:gona_market_app/data/services/api_service.dart';
import 'package:gona_market_app/logic/providers/cart_provider.dart';
import 'package:gona_market_app/logic/providers/user_provider.dart';
import 'package:gona_market_app/data/repositories/order_repository.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:gona_market_app/core/utils/customBottomSheet.dart';
import 'package:gona_market_app/core/utils/dialogModals.dart';

class DeliveryInfo {
  final String fullName;
  final String phoneNumber;
  final String email;
  final String address;

  DeliveryInfo({
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.address,
  });
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Dio _dio;
  late ApiService _apiService;

  bool saveCardDetails = false;
  String selectedPaymentType = '';
  DeliveryInfo? deliveryInfo;
  late bool _isLoading = false;

  late OrderRepository orderRepository;

  @override
  void initState() {
    super.initState();
    _dio = Dio();
    _apiService = ApiService(_dio, baseUrl: dotenv.env['API_URL'] ?? '');
    orderRepository = OrderRepository(_apiService);
  }

  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expMonthController = TextEditingController();
  final TextEditingController expYearController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  final TextEditingController pinController = TextEditingController();

  final TextEditingController otpController = TextEditingController();

  void _updateDeliveryInfo(DeliveryInfo info) {
    setState(() {
      deliveryInfo = info;
    });
  }

  Future<void> _confirmAndPay(
      double total, String userId, String paymentType) async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      showBottomSheetModal(context, "Please correct the errors in the form.");
      return;
    }

    if (deliveryInfo == null) {
      showBottomSheetModal(
          context, "Please fill in your delivery information.");
      return;
    }

    if (paymentType.isEmpty) {
      showBottomSheetModal(
          context, "Please select a payment method to proceed.");
      return;
    }

    switch (paymentType.toLowerCase()) {
      case 'card':
        loadCardDetails(context);
        break;
      default:
    }
  }

  void loadCardDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  'Card Details',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '**** **** **** 1234',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              const Text(
                                'Exp. Date',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 60,
                                    child: TextField(
                                      maxLength: 2,
                                      buildCounter: (context,
                                              {required currentLength,
                                              required isFocused,
                                              maxLength}) =>
                                          null,
                                      textAlign: TextAlign.center,
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      controller: expMonthController,
                                      decoration: InputDecoration(
                                        labelText: 'MM',
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  SizedBox(
                                    width: 60,
                                    child: TextField(
                                      maxLength: 2,
                                      buildCounter: (context,
                                              {required currentLength,
                                              required isFocused,
                                              maxLength}) =>
                                          null,
                                      textAlign: TextAlign.center,
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      controller: expYearController,
                                      decoration: InputDecoration(
                                        labelText: 'YY',
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Text(
                                'CVV',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                width: 60,
                                child: TextField(
                                  maxLength: 3,
                                  buildCounter: (context,
                                          {required currentLength,
                                          required isFocused,
                                          maxLength}) =>
                                      null,
                                  textAlign: TextAlign.center,
                                  textAlignVertical: TextAlignVertical.center,
                                  controller: cvvController,
                                  decoration: InputDecoration(
                                    labelText: '123',
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: cardNumberController,
                        decoration: InputDecoration(
                          labelText: 'Card Number',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        obscureText: false,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Card Pin: "),
                    SizedBox(
                      width: 70,
                      child: TextField(
                        obscureText: true,
                        maxLength: 4,
                        buildCounter: (context,
                                {required currentLength,
                                required isFocused,
                                maxLength}) =>
                            null,
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        controller: pinController,
                        decoration: InputDecoration(
                          labelText: '1234',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.secondary),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? CircularProgressIndicator()
                    : PrimaryButton(
                        text: _isLoading ? 'Processing...' : "Submit",
                        onPressed: () => _isLoading ? null : _submitCard(),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  void autorizeOTP(BuildContext context, data) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 400,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  'Authorize OTP',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (data['message']).toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: otpController,
                        decoration: InputDecoration(
                          labelText: 'OTP Token',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        obscureText: false,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                PrimaryButton(
                  text: _isLoading ? 'Submitting...' : "Submit",
                  onPressed: () async {
                    try {
                      final otpToken = otpController.text.trim();

                      if (otpToken.isEmpty) {
                        showBottomSheetModal(context, "Token is required!");
                        return;
                      }

                      LoadingModal.show(context, "Processing OTP...",
                          message: "Please wait...");

                      final cartProvider =
                          Provider.of<CartProvider>(context, listen: false);
                      final tokenId = data['tokenId'];
                      final transactionReference = data['transactionReference'];
                      final collectionChannel = data['collectionChannel'];
                      final items = cartProvider.cartItems.map((item) {
                        return {
                          "id": item.product.id,
                          "name": item.product.title,
                          "price": item.product.price,
                          "quantity": item.quantity,
                        };
                      }).toList();

                      var requestData = {
                        "token": otpToken,
                        "tokenId": tokenId,
                        "items": items,
                        "transactionReference": transactionReference,
                        "collectionChannel": collectionChannel,
                      };

                      var response =
                          await orderRepository.submitOTP(requestData);

                      LoadingModal.hide(context);
                      Navigator.pop(context);

                      if (response.data['success']) {
                        otpController.clear();

                        // Navigator.of(context, rootNavigator: true).popUntil((route) => route.isFirst);

                        Navigator.pop(context);
                        showMessageDialog(context, "success", "Success!",
                            "Order processed successfully!");

                        // clear cart
                        cartProvider.clearCart();
                      } else {
                        showBottomSheetModal(
                            context, "Error: ${response.data['message']}");
                      }
                      // ignore: avoid_print
                      debugPrint("Response data: ${response.data}");
                      // ignore: avoid_print
                      debugPrint("Response status: ${response.statusCode}");
                    } catch (e) {
                      LoadingModal.hide(context);
                      showBottomSheetModal(context, '$e');
                      // showBottomSheetModal(context,
                      //     "An unexpected error occurred: ${e.toString()}");
                    } finally {
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _submitCard() async {
    final cardNumber = cardNumberController.text.trim();
    final expMonth = expMonthController.text.trim();
    final expYear = expYearController.text.trim();
    final cvv = cvvController.text.trim();
    final pin = pinController.text.trim();
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    if ([cardNumber, expMonth, expYear, cvv, pin]
        .any((field) => field.isEmpty)) {
      showMessageDialog(
          context, "info", "Info!", "Please fill in all card details.");
      return;
    }

    // Navigator.pop(context);
    LoadingModal.show(context, "Processing payment...",
        message: "Please wait...");

    setState(() {
      _isLoading = true;
    });

    try {
      final items = cartProvider.cartItems.map((item) {
        return {
          'id': item.product.id,
          'name': item.product.title,
          'price': item.product.price,
          'quantity': item.quantity,
        };
      }).toList();

      var data = {
        'cardNumber': cardNumber,
        'expiryMonth': expMonth,
        'expiryYear': expYear,
        'cvv': cvv,
        'pin': pin,
        'amount': cartProvider.totalPrice,
        'items': items,
      };

      var response = await orderRepository.submitOrder('card', data);
      final responseData = response.data;

      cardNumberController.clear();
      expMonthController.clear();
      expYearController.clear();
      cvvController.clear();
      pinController.clear();
      otpController.clear();

      if (responseData['success'] == false &&
          responseData['OTP_AUTHORIZATION_REQUIRED'] == true) {
        LoadingModal.hide(context);
        Navigator.pop(context);

        autorizeOTP(context, responseData);
        return;
      }

      // ignore: use_build_context_synchronously
      LoadingModal.hide(context);
      Navigator.pop(context);

      showMessageDialog(
          // ignore: use_build_context_synchronously
          context,
          "success",
          "Success!",
          "Order processed successfully!");
    } catch (e) {
      LoadingModal.hide(context);
      showMessageDialog(context, "error", "Error!", e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final total = cartProvider.totalPrice;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.yellow),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Checkout',
          style: TextStyle(
            color: Colors.yellow,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                NumberFormat.simpleCurrency(locale: 'en_NG', name: '₦')
                    .format(total),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const CheckOutReview(),
                      const SizedBox(height: 20),
                      ShippingInformation(
                          onDeliveryInfoChanged: _updateDeliveryInfo),
                      const SizedBox(height: 20),
                      PaymentMethod(
                        onPaymentTypeSelected: (String paymentType) {
                          setState(() {
                            selectedPaymentType = paymentType;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  final userId = userProvider.user!.id ?? 'guest';
                  return SecondaryButton(
                    text:
                        "CONFIRM & PAY (${NumberFormat.simpleCurrency(locale: 'en_NG', name: '₦').format(total)})",
                    onPressed: _isLoading
                        ? () {
                            return;
                          }
                        : () {
                            _confirmAndPay(
                                total, userId.toString(), selectedPaymentType);
                          },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class CheckOutReview extends StatelessWidget {
  const CheckOutReview({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final cartItems = cartProvider.cartItems;
    final total = cartProvider.totalPrice;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final item = cartItems[index];
              return ListTile(
                title: Text(
                  item.product.title,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold),
                ),
                subtitle: Text('Qty: ${item.quantity}'),
                trailing: Text(
                  NumberFormat.simpleCurrency(locale: 'en_NG', name: '₦')
                      .format(item.product.price),
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              );
            },
          ),
          const Divider(),
          Text(
            'Total: ${NumberFormat.simpleCurrency(locale: 'en_NG', name: '₦').format(total)}',
            style: const TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
          ),
        ],
      ),
    );
  }
}

class ShippingInformation extends StatefulWidget {
  final Function(DeliveryInfo) onDeliveryInfoChanged;

  const ShippingInformation({super.key, required this.onDeliveryInfoChanged});

  @override
  State<ShippingInformation> createState() => _ShippingInformationState();
}

class _ShippingInformationState extends State<ShippingInformation> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers to free up resources.
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user;

    if (user != null) {
      // Pre-fill the fields if user information is available.
      _nameController.text = user.fullName ?? '';
      _phoneController.text = user.phoneNumber ?? '';
      _emailController.text = user.email ?? '';
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Shipping Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Full Name',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your full name';
              }
              return null; // Return null if validation is successful.
            },
            onChanged: (value) {
              widget.onDeliveryInfoChanged(_createDeliveryInfo());
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              return null; // Return null if validation is successful.
            },
            onChanged: (value) {
              widget.onDeliveryInfoChanged(_createDeliveryInfo());
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email Address',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email address';
              }
              return null; // Return null if validation is successful.
            },
            onChanged: (value) {
              widget.onDeliveryInfoChanged(_createDeliveryInfo());
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _addressController,
            decoration: const InputDecoration(
              labelText: 'Address',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your address';
              }
              return null; // Return null if validation is successful.
            },
            onChanged: (value) {
              widget.onDeliveryInfoChanged(_createDeliveryInfo());
            },
          ),
        ],
      ),
    );
  }

  DeliveryInfo _createDeliveryInfo() {
    return DeliveryInfo(
      fullName: _nameController.text,
      phoneNumber: _phoneController.text,
      email: _emailController.text,
      address: _addressController.text,
    );
  }
}

class PaymentMethod extends StatefulWidget {
  final Function(String) onPaymentTypeSelected;

  const PaymentMethod({
    super.key,
    required this.onPaymentTypeSelected,
  });

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  String selectedPayment = '';
  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      width: deviceWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Method',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                PaymentMethodButton(
                  label: 'Card',
                  icon: Icons.credit_card,
                  isSelected: selectedPayment == 'Card',
                  onTap: () {
                    setState(() {
                      selectedPayment = 'Card';
                    });
                    widget.onPaymentTypeSelected('Card');
                  },
                ),
                const SizedBox(width: 10),
                PaymentMethodButton(
                  label: 'Transfer',
                  icon: Icons.account_balance,
                  isSelected: selectedPayment == 'Transfer',
                  onTap: () {
                    setState(() {
                      selectedPayment = 'Transfer';
                    });
                    widget.onPaymentTypeSelected('Transfer');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentMethodButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentMethodButton({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
            width: 3,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          children: [
            Icon(icon,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.white),
            const SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
