import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/liked.dart';
import '../../models/products.dart';

class LikedItem extends StatelessWidget {
  final Product product;
  final VoidCallback? onRemove;

  const LikedItem({
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
      margin: EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Image.network(product.imagePath),
        title: Text(product.name),
        subtitle: Text('\$' + product.price),
        trailing: IconButton(
          onPressed: onRemove,
          icon: Icon(Icons.delete),
        ),
      ),
    );
  }
}
