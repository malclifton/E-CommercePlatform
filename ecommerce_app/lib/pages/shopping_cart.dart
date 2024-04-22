import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/cart_item.dart';
import '../models/cart.dart';
import '../models/products.dart';

class ShoppingCart extends StatelessWidget {
  const ShoppingCart({super.key});

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
                  Text(
                    "My Cart",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  IconButton(
                    onPressed: () {
                      cart.clearCart();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Purchase Complete! Your items are on the way!'),
                        ),
                      );
                    },
                    icon: Icon(Icons.shopping_cart_checkout),
                    tooltip: 'Clear Cart',
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('user_cart')
                    .doc('defaultUserId') // Adjust with actual user ID
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (!snapshot.hasData ||
                      snapshot.data!.data() == null) {
                    return Center(child: Text('No items in cart'));
                  } else {
                    // Cast data to Map<String, dynamic> to avoid '[]' operator error
                    Map<String, dynamic> cartData =
                        snapshot.data!.data() as Map<String, dynamic>;
                    List<dynamic> cartItems = cartData['cart_items'];
                    List<Product> products =
                        cartItems.map((item) => Product.fromMap(item)).toList();
                    return ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return CartItem(product: products[index]);
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
