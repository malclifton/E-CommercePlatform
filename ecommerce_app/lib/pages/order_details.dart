import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderDetailsPage extends StatelessWidget {
  final String orderId;

  const OrderDetailsPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('user_orders')
            .doc(orderId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading order details'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Order not found'));
          }

          final orderData = snapshot.data!.data() as Map<String, dynamic>;
          final orderDate = orderData['order_date'] as Timestamp;
          final products = orderData['products'] as List<dynamic>;

          return ListView(
            children: [
              ListTile(
                title: Text('Order ID: $orderId'),
                subtitle: Text('Order Date: ${orderDate.toDate()}'),
              ),
              const Divider(),
              const Text(
                'Products:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index] as Map<String, dynamic>;
                  return ListTile(
                    leading: Image.network(product['imagePath'].toString()),
                    title: Text(product['name'].toString()),
                    subtitle: Text('\$${product['price']}'),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
