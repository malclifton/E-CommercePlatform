import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart.dart';
import '../models/liked.dart';
import '../models/products.dart';
import '../components/products_tile.dart';
import 'catalog.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ProductService? _productService;
  Future<List<Product>>? _productsFuture;
  TextEditingController? _searchController;
  String userId =
      FirebaseAuth.instance.currentUser?.uid ?? ''; // Get current user's ID

  void addItemToCart(Product product) {
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

  void addItemToLiked(Product product) {
    Provider.of<Liked>(context, listen: false).addItemToLiked(product);

    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        title: Text('Successfully added!'),
        content: Text('Check your wishlist'),
        backgroundColor: Colors.white,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _productService = ProductService();
    _productsFuture =
        _productService!.getProducts(); // Fetch products from the collection
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController?.dispose();
    super.dispose();
  }

  List<Product> filterProducts(List<Product> products, String query) {
    return products.where((product) {
      final nameLower = product.name.toLowerCase();
      final queryLower = query.toLowerCase();
      return nameLower.contains(queryLower);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (context, value, child) => Column(
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
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _searchController!.clear();
                    setState(() {});
                  },
                  icon: const Icon(Icons.clear),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 25.0),
            child: Text("find your next treasure..."),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Trending Items🌟",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Catalog()),
                    );
                  },
                  child: const Text(
                    "See all",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
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
                  List<Product>? allProducts = snapshot.data;
                  if (allProducts != null && allProducts.isNotEmpty) {
                    List<Product> filteredProducts = _searchController!
                            .text.isNotEmpty
                        ? filterProducts(allProducts, _searchController!.text)
                        : allProducts;

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ProductsTile(
                            product: filteredProducts[index],
                            onTap: () => addItemToCart(filteredProducts[index]),
                            isLiked: false,
                            onLikePressed: () =>
                                addItemToLiked(filteredProducts[index]),
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
          const Padding(
            padding: EdgeInsets.only(
              top: 25.0,
              left: 25.0,
              right: 25.0,
            ),
            child: Divider(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
