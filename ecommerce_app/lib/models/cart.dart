import 'package:flutter/material.dart';

import 'products.dart';

class Cart extends ChangeNotifier {
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
    notifyListeners();
  }

  //remove item from cart
  void removeItemFromCart(Product product) {
    userCart.remove(product);
    notifyListeners();
  }
}
