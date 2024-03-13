import 'package:drag_and_drop/utils/menuitem.dart';
import 'package:flutter/material.dart';

class CheckoutScreen extends StatelessWidget {
  final List<MenuItem> cartItems;
  final double totalPrice;

  const CheckoutScreen({
    Key? key,
    required this.cartItems,
    required this.totalPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return ListTile(
                  title: Text('Item ${index + 1}: ${item.name}'),
                  subtitle: Text('Price: Rs. ${item.price.toStringAsFixed(2)}'),
                  trailing: Text('Status: Rs. ${item.isSuccessful}'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Total: Rs. ${totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Perform NFC scanning
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.nfc),
                      SizedBox(width: 8),
                      Text('Scan NFC Card'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
