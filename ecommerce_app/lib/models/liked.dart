import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'products.dart';

class Liked extends ChangeNotifier {
  List<Product> userLiked = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> loadUserFavorites() async {
    try {
      // Get the current user ID or use a default user ID for testing
      String userId = 'defaultUserId';

      // Fetch user favorites from Firestore
      DocumentSnapshot doc =
          await _firestore.collection('user_favorite').doc(userId).get();
      if (doc.exists) {
        // Explicitly cast data to Map<String, dynamic>
        Map<String, dynamic>? favoritesData =
            doc.data() as Map<String, dynamic>?;

        // Check if favoritesData is not null and contains 'favorites' key
        if (favoritesData != null && favoritesData.containsKey('favorites')) {
          List<dynamic> favoritesList =
              favoritesData['favorites'] as List<dynamic>;
          userLiked =
              favoritesList.map((item) => Product.fromMap(item)).toList();
          notifyListeners();
        }
      }
    } catch (e) {
      print('Error loading user favorites: $e');
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
      // Get the current user ID or use a default user ID for testing
      String userId = 'defaultUserId';

      // Update the 'user_favorite' collection for the user with their liked items
      await _firestore.collection('user_favorite').doc(userId).set({
        'favorites': userLiked.map((item) => item.toMap()).toList(),
      });
    } catch (e) {
      print('Error updating user favorites in Firestore: $e');
    }
  }
}
