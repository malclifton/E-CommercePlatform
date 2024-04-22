import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'products.dart';

class Cart extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //list of products for $
  List<Product> productShop = [];
  //list of all items in user cart
  List<Product> userCart = [];

  final ProductService _productService = ProductService();

  Future<void> getProductsFromFirebase() async {
    try {
      List<Product> products = await _productService.getProducts();
      productShop = products;
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  //get list of products for $
  List<Product> getProductList() {
    return productShop;
  }

  //get cart
  List<Product> getCartList() {
    return userCart;
  }

  //add items to cart
  void addItemToCart(Product product) {
    userCart.add(product);
    _updateUserCartInFirestore(userCart);
    notifyListeners();
  }

  Future<void> _updateUserCartInFirestore(List<Product> cartItems) async {
    try {
      // Get the current user ID or use a default user ID for testing
      String userId = 'defaultUserId';

      // Update the 'user_cart' collection for the user with their cart items
      await _firestore.collection('user_cart').doc(userId).set({
        'cart_items': cartItems.map((item) => item.toMap()).toList(),
      });
    } catch (e) {
      print('Error updating user cart in Firestore: $e');
    }
  }

  //remove item from cart
  void removeItemFromCart(Product product) {
    userCart.remove(product);
    notifyListeners();
  }

  void clearCart() {
    userCart.clear();
    notifyListeners();
  }
}
