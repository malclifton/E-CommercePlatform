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
          _userId = currentUser.uid;
          DocumentSnapshot userData = await FirebaseFirestore.instance
              .collection('credentials')
              .doc(currentUser.uid)
              .get();
          if (userData.exists) {
            _userId = userData['userId'];
            DocumentSnapshot cartData =
                await _firestore.collection('user_cart').doc(_userId!).get();
            if (cartData.exists) {
              Map<String, dynamic>? cartDataMap =
                  cartData.data() as Map<String, dynamic>?;
              if (cartDataMap != null &&
                  cartDataMap.containsKey('cart_items')) {
                List<dynamic> cartItemsData = cartDataMap['cart_items'];
                userCart =
                    cartItemsData.map((item) => Product.fromMap(item)).toList();
                notifyListeners();
              } else {
                print(
                    'Error: cart_items field does not exist in user cart document');
              }
            } else {
              print('User cart document does not exist, creating...');
              await _firestore.collection('user_cart').doc(_userId!).set({
                'cart_items': [],
              });
              print('User cart document created.');
            }
          } else {
            print('Error: User data not found');
          }
        }
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
      double itemPrice = double.tryParse(item.price) ?? 0;
      totalPrice += itemPrice;
    }
    return totalPrice;
  }
}
