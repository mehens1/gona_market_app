import 'package:flutter/material.dart';
import 'package:gona_market_app/core/widgets/button.dart';
import 'package:gona_market_app/core/widgets/secondary_button.dart';
import 'package:gona_market_app/logic/providers/cart_provider.dart';
import 'package:gona_market_app/logic/providers/user_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// Class to hold delivery information.
class DeliveryInfo {
  // The following line was commented out and can be removed if not used.
  // final String userId; // If userId is not needed, remove it.
  final String fullName;
  final String phoneNumber;
  final String email;
  final String address;

  DeliveryInfo({
    // required this.userId, // Uncomment if userId is needed.
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.address,
  });
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool saveCardDetails = false; // This variable is declared but not used.
  String selectedPaymentType = '';
  DeliveryInfo? deliveryInfo;
  bool _isLoading = false;

  // Updates the delivery information.
  void _updateDeliveryInfo(DeliveryInfo info) {
    setState(() {
      deliveryInfo = info;
    });
  }

  // Confirm payment and process transaction.
  Future<void> _confirmAndPay(
      double total, String userId, String paymentType) async {
    // Validate the form fields and delivery info.
    if (!(_formKey.currentState?.validate() ?? false)) {
      _showErrorModal(context, "Please correct the errors in the form.");
      return;
    }

    if (deliveryInfo == null) {
      _showErrorModal(context, "Please fill in your delivery information.");
      return;
    }

    if (paymentType.isEmpty) {
      _showErrorModal(context, "Please select a payment method to proceed.");
      return;
    }

    // if(paymentType == )
    switch (paymentType.toLowerCase()) {
      case 'card':
        loadCardDetails(context);
        break;
      default:
    }

    print("Mehens _formKey");
    print(_formKey.toString());
    print('');

    print("Mehens paymentType");
    print(paymentType);
    print('');
  }

  // Display card and allow user to put in card details
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
                      Text(
                        '**** **** **** 1234', // Example card number
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
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
                                  SizedBox(width: 10),
                                  SizedBox(
                                    width: 60,
                                    child: TextField(
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
                      SizedBox(height: 20),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Card Number',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        obscureText: true,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Card Pin: "),
                    SizedBox(
                      width: 70,
                      child: TextField(
                        obscureText: true,
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

                PrimaryButton(
                  text: "Submit",
                  onPressed: () {},
                )
                // ElevatedButton(
                //   onPressed: () {
                //     // Implement card processing logic here
                //     Navigator.pop(context);
                //   },
                //   child: Text('Submit'),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Displays an error modal with a message.
  void _showErrorModal(BuildContext context, String errorMessage) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.redAccent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Error',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  errorMessage,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('OK'),
                ),
              ],
            ),
          ),
        );
      },
    );
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
                          onDeliveryInfoChanged:
                              _updateDeliveryInfo), // Pass the function directly.
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
                    onPressed: _isLoading // Disable button when loading.
                        ? () {
                            return null;
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

// This class holds the shipping information form.
class ShippingInformation extends StatefulWidget {
  final Function(DeliveryInfo) onDeliveryInfoChanged;

  const ShippingInformation({required this.onDeliveryInfoChanged});

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










// // This class represents the payment method selection.
// class PaymentMethod extends StatelessWidget {
//   final Function(String) onPaymentTypeSelected;

//   const PaymentMethod({required this.onPaymentTypeSelected});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Payment Method',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Theme.of(context).colorScheme.secondary,
//             ),
//           ),
//           const SizedBox(height: 10),
//           RadioListTile(
//             title: const Text('Credit Card'),
//             value: 'credit_card',
//             groupValue: null, // This should be managed by the parent.
//             onChanged: (value) {
//               if (value != null) {
//                 onPaymentTypeSelected(value);
//               }
//             },
//           ),
//           RadioListTile(
//             title: const Text('PayPal'),
//             value: 'paypal',
//             groupValue: null, // This should be managed by the parent.
//             onChanged: (value) {
//               if (value != null) {
//                 onPaymentTypeSelected(value);
//               }
//             },
//           ),
//           // Additional payment methods can be added similarly.
//         ],
//       ),
//     );
//   }
// }
