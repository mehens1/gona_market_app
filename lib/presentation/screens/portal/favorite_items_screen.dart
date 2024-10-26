import 'package:flutter/material.dart';
import 'package:gona_market_app/logic/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool saveCardDetails = false;

  @override
  Widget build(BuildContext context) {

    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cartItems;
    final total = cartProvider.totalPrice;
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.yellow),
          onPressed: () {},
        ),
        title: Text('Checkout', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                "$total",
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // const Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     PaymentMethodButton(label: 'Nagad', icon: Icons.flash_on, isSelected: false),
            //     SizedBox(width: 8),
            //     PaymentMethodButton(label: 'Card', icon: Icons.credit_card, isSelected: true),
            //     SizedBox(width: 8),
            //     PaymentMethodButton(label: 'Other', icon: Icons.local_atm, isSelected: false),
            //   ],
            // ),
            SizedBox(height: 20),

            // Card Number Input
            CardDetailsSection(),

            const Spacer(),

            // Confirm & Pay Button
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 100),
              ),
              child: const Text(
                'CONFIRM & PAY',
                style: TextStyle(color: Colors.blueAccent, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentMethodButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;

  const PaymentMethodButton({
    required this.label,
    required this.icon,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.blue.shade700,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? Colors.blue : Colors.white),
              SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.blue : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardDetailsSection extends StatefulWidget {
  @override
  _CardDetailsSectionState createState() => _CardDetailsSectionState();
}

class _CardDetailsSectionState extends State<CardDetailsSection> {
  bool saveCardDetails = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Number
          TextField(
            decoration: InputDecoration(
              labelText: 'CARD NUMBER',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 16),

          // Name on Card
          TextField(
            decoration: InputDecoration(
              labelText: 'NAME ON CARD',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          SizedBox(height: 16),

          // Expiration Date and CCV
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'EXPIRES DATE',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'CCV',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Save card details toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Save card details'),
              Switch(
                value: saveCardDetails,
                onChanged: (value) {
                  setState(() {
                    saveCardDetails = value;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:gona_market_app/logic/providers/cart_provider.dart';
// import 'package:gona_market_app/core/widgets/custom_snackbar.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';

// class CheckoutScreen extends StatefulWidget {
//   const CheckoutScreen({super.key});

//   @override
//   _CheckoutScreenState createState() => _CheckoutScreenState();
// }

// class _CheckoutScreenState extends State<CheckoutScreen> {
//   final _formKey = GlobalKey<FormState>();
//   String _name = '';
//   String _phoneNumber = '';
//   String _address = '';
//   String _paymentMethod = 'Card Payment';

//   @override
//   Widget build(BuildContext context) {
//     final cartProvider = Provider.of<CartProvider>(context);
//     final cartItems = cartProvider.cartItems;
//     final total = cartProvider.totalPrice;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Checkout'),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Order Summary
//             const Text(
//               'Order Summary',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             ListView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: cartItems.length,
//               itemBuilder: (context, index) {
//                 final item = cartItems[index];
//                 return ListTile(
//                   title: Text(item.product.title),
//                   subtitle: Text('Quantity: ${item.quantity}'),
//                   trailing: Text(NumberFormat.simpleCurrency(locale: 'en_NG', name: '₦')
//                       .format(item.product.price)),
//                 );
//               },
//             ),
//             const Divider(),
//             Text(
//               'Total: ${NumberFormat.simpleCurrency(locale: 'en_NG', name: '₦').format(total)}',
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),

//             // Delivery Information
//             const Text(
//               'Delivery Information',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             Form(
//               key: _formKey,
//               child: Column(
//                 children: [
//                   TextFormField(
//                     decoration: const InputDecoration(labelText: 'Name'),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your name';
//                       }
//                       return null;
//                     },
//                     onSaved: (value) {
//                       _name = value ?? '';
//                     },
//                   ),
//                   const SizedBox(height: 10),
//                   TextFormField(
//                     decoration: const InputDecoration(labelText: 'Phone Number'),
//                     keyboardType: TextInputType.phone,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your phone number';
//                       }
//                       return null;
//                     },
//                     onSaved: (value) {
//                       _phoneNumber = value ?? '';
//                     },
//                   ),
//                   const SizedBox(height: 10),
//                   TextFormField(
//                     decoration: const InputDecoration(labelText: 'Delivery Address'),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your address';
//                       }
//                       return null;
//                     },
//                     onSaved: (value) {
//                       _address = value ?? '';
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),

//             // Payment Method
//             const Text(
//               'Payment Method',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             DropdownButtonFormField<String>(
//               value: _paymentMethod,
//               decoration: const InputDecoration(
//                 labelText: 'Select Payment Method',
//                 border: OutlineInputBorder(),
//               ),
//               items: ['Card Payment', 'Bank Transfer', 'Cash on Delivery']
//                   .map((String method) {
//                 return DropdownMenuItem<String>(
//                   value: method,
//                   child: Text(method),
//                 );
//               }).toList(),
//               onChanged: (newValue) {
//                 setState(() {
//                   _paymentMethod = newValue!;
//                 });
//               },
//             ),
//             const SizedBox(height: 30),

//             // Checkout Button
//             Center(
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//                   backgroundColor: Theme.of(context).colorScheme.primary,
//                 ),
//                 onPressed: () {
//                   if (_formKey.currentState!.validate()) {
//                     _formKey.currentState!.save();
//                     _performCheckout(context, total);
//                   }
//                 },
//                 child: const Text('Place Order', style: TextStyle(fontSize: 16)),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _performCheckout(BuildContext context, double total) {
//     CustomSnackbar.show(
//       context,
//       'Order placed successfully! Total: ₦${NumberFormat.simpleCurrency(locale: 'en_NG', name: '₦').format(total)}',
//     );

//     Provider.of<CartProvider>(context, listen: false).clearCart();

//     Navigator.pop(context);
//   }
// }
