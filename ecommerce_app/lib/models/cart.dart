// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'products.dart';

class Cart extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _userId;
  final bool _cartLoaded = false;

  List<Product> productShop = [];
  List<Product> userCart = [];

  Future<void> loadUserCart() async {
    try {
      if (_userId == null) {
        User? currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          DocumentSnapshot userData = await FirebaseFirestore.instance
              .collection('credentials')
              .doc(currentUser.uid)
              .get();

          _userId = userData['userId'];
        }
      }

      if (_userId != null) {
        DocumentSnapshot cartData =
            await _firestore.collection('user_cart').doc(_userId!).get();

        if (cartData.exists) {
          // Check if 'cart_items' field exists and load cart items
          Map<String, dynamic>? cartDataMap =
              cartData.data() as Map<String, dynamic>?;
          if (cartDataMap != null && cartDataMap.containsKey('cart_items')) {
            List<dynamic> cartItemsData = cartDataMap['cart_items'];
            userCart =
                cartItemsData.map((item) => Product.fromMap(item)).toList();
            notifyListeners();
          } else {
            print(
                'Error: cart_items field does not exist in user cart document');
          }
        } else {
          print('Error: User cart document does not exist');
        }
      } else {
        print('Error: User ID is null');
      }
    } catch (e) {
      print('Error loading user cart: $e');
    }
  }

  void addItemToCart(Product product) {
    userCart.add(product);
    _updateUserCartInFirestore(userCart);
    notifyListeners();
  }

  Future<void> _updateUserCartInFirestore(List<Product> cartItems) async {
    try {
      // Update the 'user_cart' collection for the user with their cart items
      await _firestore.collection('user_cart').doc(_userId!).set({
        'cart_items': cartItems.map((item) => item.toMap()).toList(),
      });
    } catch (e) {
      print('Error updating user cart in Firestore: $e');
    }
  }

  void removeItemFromCart(Product product) {
    userCart.remove(product);
    _updateUserCartInFirestore(userCart);
    notifyListeners();
  }

  void clearCart() async {
    try {
      userCart.clear();
      // Delete the 'user_cart' document from Firestore
      await _firestore.collection('user_cart').doc(_userId!).delete();
      notifyListeners();
    } catch (e) {
      print('Error clearing cart and deleting document: $e');
    }
  }

  List<Product> getCartList() {
    return userCart;
  }

  bool isCartLoaded() {
    return _cartLoaded;
  }

  double calculateTotalPrice() {
    double totalPrice = 0;
    for (var item in userCart) {
      double itemPrice = double.parse(item.price);
      totalPrice += itemPrice;
    }
    return totalPrice;
  }
}
