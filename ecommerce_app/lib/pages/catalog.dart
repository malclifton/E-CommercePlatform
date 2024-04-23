import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart.dart';
import '../models/liked.dart';
import '../models/products.dart';
import '../components/products_tile.dart';

class Catalog extends StatefulWidget {
  const Catalog({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CatalogState createState() => _CatalogState();
}

class _CatalogState extends State<Catalog> {
  ProductService? _productService;
  Future<List<Product>>? _productsFuture;
  TextEditingController? _searchController;
  String userId =
      FirebaseAuth.instance.currentUser?.uid ?? ''; // Get current user's ID

  @override
  void initState() {
    super.initState();
    _productService = ProductService();
    _productsFuture = _productService!.getAllProducts();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController?.dispose();
    super.dispose();
  }

  Future<void> _searchProducts(String query) async {
    setState(() {
      _productsFuture = _productService!.searchProducts(query);
    });
  }

  void addItemToCart(BuildContext context, Product product) {
    Provider.of<Cart>(context, listen: false).addItemToCart(product);

    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        title: Text('Successfully added!'),
        content: Text('Check your cart'),
        backgroundColor: Colors.white,
      ),
    );
  }

  void addItemToLiked(BuildContext context, Product product) {
    context.read<Liked>().addItemToLiked(product);

    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        title: Text('Successfully added!'),
        content: Text('Check your Wishlist'),
        backgroundColor: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Catalog',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(horizontal: 25),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search products...',
                      border: InputBorder.none,
                    ),
                    onChanged: _searchProducts,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _searchController!.clear();
                    _searchProducts('');
                  },
                  icon: const Icon(Icons.clear),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: _productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error fetching data'));
                } else {
                  List<Product>? products = snapshot.data;
                  if (products != null && products.isNotEmpty) {
                    return ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ProductsTile(
                            product: products[index],
                            onTap: () =>
                                addItemToCart(context, products[index]),
                            isLiked: false,
                            onLikePressed: () =>
                                addItemToLiked(context, products[index]),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text('No products available'));
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
