import 'package:cloud_firestore/cloud_firestore.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Product>> getProducts() async {
    QuerySnapshot querySnapshot = await _firestore.collection('products').get();
    return querySnapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
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
}
