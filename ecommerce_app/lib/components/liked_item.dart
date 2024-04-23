import 'package:flutter/material.dart';

import '../../models/products.dart';

class LikedItem extends StatelessWidget {
  final Product product;
  final VoidCallback? onRemove;

  const LikedItem({
    super.key,
    required this.product,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Image.network(product.imagePath),
        title: Text(product.name),
        subtitle: Text('\$${product.price}'),
        trailing: IconButton(
          onPressed: onRemove,
          icon: const Icon(Icons.delete),
        ),
      ),
    );
  }
}
