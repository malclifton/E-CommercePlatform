import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart.dart';
import '../models/products.dart';
import '../products_tile.dart';
import 'catalog.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ProductService? _productService;
  Future<List<Product>>? _productsFuture;
  //add product to cart
  void addItemToCart(Product product) {
    Provider.of<Cart>(context, listen: false).addItemToCart(product);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Successfully added!'),
        content: Text('Check your cart'),
        backgroundColor: Colors.white,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _productService = ProductService();
    _productsFuture = _productService?.getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (context, value, child) => Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.symmetric(horizontal: 25),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Search',
                  style: TextStyle(color: Colors.grey),
                ),
                Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 25.0),
            child: Text("find your next treasure..."),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Trending Items🌟",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Catalog()),
                    );
                  },
                  child: Text(
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
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error fetching data'));
                } else {
                  List<Product>? products = snapshot.data;
                  if (products != null && products.isNotEmpty) {
                    return ListView(
                      scrollDirection:
                          Axis.horizontal, // Set horizontal scroll direction
                      children: products.map((product) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ProductsTile(
                            product: product,
                            onTap: () => addItemToCart(product),
                          ),
                        );
                      }).toList(),
                    );
                  } else {
                    return Center(child: Text('No products available'));
                  }
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
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
