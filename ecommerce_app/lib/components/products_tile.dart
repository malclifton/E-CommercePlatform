import 'package:flutter/material.dart';

import '../models/products.dart';

// ignore: must_be_immutable
class ProductsTile extends StatefulWidget {
  Product product;
  void Function()? onTap;
  void Function()? onLikePressed;
  bool isLiked;

  ProductsTile(
      {super.key,
      required this.product,
      required this.onTap,
      required this.isLiked,
      required this.onLikePressed});

  @override
  State<ProductsTile> createState() => _ProductsTileState();
}

class _ProductsTileState extends State<ProductsTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 25),
      width: 350,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: GestureDetector(
              onTap: widget.onLikePressed,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: widget.isLiked ? Colors.red : Colors.black,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Icon(
                  widget.isLiked ? Icons.favorite : Icons.favorite_border,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 210,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                widget.product.imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              widget.product.description,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '\$${widget.product.price}',
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
