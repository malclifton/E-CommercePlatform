// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'products.dart';

class Liked extends ChangeNotifier {
  List<Product> userLiked = [];
  String? _userId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> loadUserFavorites() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        _userId = currentUser.uid;
        DocumentSnapshot likedData =
            await _firestore.collection('user_favorites').doc(_userId).get();

        if (likedData.exists) {
          List<dynamic> likedItemsData = likedData['liked_items'];
          userLiked =
              likedItemsData.map((item) => Product.fromMap(item)).toList();
        } else {
          await _firestore.collection('user_favorites').doc(_userId).set({
            'liked_items': [],
          });
          userLiked = [];
        }
        notifyListeners();
      } else {
        print('Error: Current user is null');
      }
    } catch (e) {
      print('Error loading user liked: $e');
    }
  }

  Future<void> addItemToLiked(Product product) async {
    try {
      userLiked.add(product);
      await _updateUserFavoritesInFirestore();
      notifyListeners();
    } catch (e) {
      print('Error adding item to liked: $e');
    }
  }

  Future<void> removeItemFromLiked(Product product) async {
    try {
      userLiked.remove(product);
      await _updateUserFavoritesInFirestore();
      notifyListeners();
    } catch (e) {
      print('Error removing item from liked: $e');
    }
  }

  Future<void> _updateUserFavoritesInFirestore() async {
    try {
      await _firestore.collection('user_favorites').doc(_userId).set({
        'liked_items': userLiked.map((item) => item.toMap()).toList(),
      });
    } catch (e) {
      print('Error updating user favorites in Firestore: $e');
    }
  }

  Future<void> deleteItemFromFirestore(Product product) async {
    try {
      await _firestore
          .collection('user_favorites')
          .doc(_userId)
          .update({
            'liked_items': FieldValue.arrayRemove([product.toMap()])
          })
          .then((value) => print('Item deleted from Firestore'))
          .catchError((error) => print('Failed to delete item: $error'));
    } catch (e) {
      print('Error deleting item from Firestore: $e');
    }
  }
}
