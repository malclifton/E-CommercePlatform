import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/cart_item.dart';
import '../models/cart.dart';
import '../models/products.dart';

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  void storeOrderInFirestore(List<Product> products) async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;

    if (userId != null) {
      // Create a new document under 'user_orders' with a unique ID
      final newOrderRef =
          FirebaseFirestore.instance.collection('user_orders').doc();
      final orderDate = DateTime.now();

      await newOrderRef.set({
        'user_id': userId,
        'order_date': orderDate,
        'products': products.map((product) => product.toMap()).toList(),
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Provider.of<Cart>(context, listen: false).loadUserCart();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (context, cart, child) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "My Cart",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '\$${cart.calculateTotalPrice().toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      storeOrderInFirestore(cart.getCartList());
                      cart.clearCart();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Purchase Complete! Your items are on the way!'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.shopping_cart_checkout),
                    tooltip: 'Checkout',
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: cart.getCartList().length,
                itemBuilder: (context, index) {
                  return CartItem(product: cart.getCartList()[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
