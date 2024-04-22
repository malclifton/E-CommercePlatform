import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_app/models/liked.dart';
import 'package:ecommerce_app/components/liked_item.dart';

class Favorite extends StatelessWidget {
  const Favorite({Key? key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Liked>(
      builder: (context, liked, child) => Padding(
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
                    "My Wishlist",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: () async {
                      await liked.loadUserFavorites(); // Refresh user favorites
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: liked.userLiked.length,
                itemBuilder: (context, index) {
                  return LikedItem(
                    product: liked.userLiked[index],
                    onRemove: () async {
                      await liked.removeItemFromLiked(liked.userLiked[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
