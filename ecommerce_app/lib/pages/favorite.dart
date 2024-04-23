import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_app/models/liked.dart';
import 'package:ecommerce_app/components/liked_item.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  @override
  void initState() {
    super.initState();
    Provider.of<Liked>(context, listen: false).loadUserFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final liked = Provider.of<Liked>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Wishlist',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: liked.userLiked.isEmpty
          ? const Center(child: Text('No items in your wishlist'))
          : ListView.builder(
              itemCount: liked.userLiked.length,
              itemBuilder: (context, index) {
                final product = liked.userLiked[index];
                return Dismissible(
                  key: Key(product.name),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) {
                    liked.removeItemFromLiked(product);
                    liked.deleteItemFromFirestore(product);
                  },
                  background: Container(
                    alignment: Alignment.centerRight,
                    color: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: LikedItem(
                    product: product,
                    onRemove: () {
                      liked.removeItemFromLiked(product);
                      liked.deleteItemFromFirestore(product);
                    },
                  ),
                );
              },
            ),
    );
  }
}
