import 'package:cloud_firestore/cloud_firestore.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Product>> getProducts() async {
    QuerySnapshot querySnapshot = await _firestore.collection('products').get();
    return querySnapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
  }

  Future<List<Product>> getAllProducts() async {
    QuerySnapshot querySnapshot =
        await _firestore.collection('all_products').get();
    return querySnapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
  }

  Future<List<Product>> searchProducts(String query) async {
    // Search in both 'products' and 'all_products' collections
    QuerySnapshot querySnapshot1 = await _firestore
        .collection('products')
        .where('product-name', isGreaterThanOrEqualTo: query)
        .where('product-name', isLessThan: query + 'z')
        .get();
    QuerySnapshot querySnapshot2 = await _firestore
        .collection('all_products')
        .where('product-name', isGreaterThanOrEqualTo: query)
        .where('product-name', isLessThan: query + 'z')
        .get();

    List<Product> products1 =
        querySnapshot1.docs.map((doc) => Product.fromFirestore(doc)).toList();
    List<Product> products2 =
        querySnapshot2.docs.map((doc) => Product.fromFirestore(doc)).toList();

    return [...products1, ...products2];
  }
}

class Product {
  final String imagePath;
  final String name;
  final String price;
  final String description;

  Product({
    required this.imagePath,
    required this.name,
    required this.price,
    required this.description,
  });

  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Product(
      description: data['product-description'],
      imagePath: data['product-img'],
      name: data['product-name'],
      price: data['product-price'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'imagePath': imagePath,
      'name': name,
      'price': price,
      'description': description,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      imagePath: map['imagePath'] ?? '',
      name: map['name'] ?? '',
      price: map['price'] ?? '',
      description: map['description'] ?? '',
    );
  }
}
