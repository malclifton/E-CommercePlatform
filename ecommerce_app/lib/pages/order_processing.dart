import 'package:ecommerce_app/pages/order_details.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('user_orders')
            .where('user_id', isEqualTo: user?.uid)
            .orderBy('order_date', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            // ignore: avoid_print
            print('Error fetching order history: ${snapshot.error}');
            return const Center(child: Text('Error fetching order history'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data?.docs;

          if (orders == null || orders.isEmpty) {
            return const Center(child: Text('No orders found'));
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index].data() as Map<String, dynamic>;
              final orderId = orders[index].id;

              final orderDate = order['order_date'] as Timestamp;
              final formattedDate = DateTime.fromMillisecondsSinceEpoch(
                      orderDate.millisecondsSinceEpoch)
                  .toString();

              return ListTile(
                title: Text('Order ID: $orderId'),
                subtitle: Text('Order Date: $formattedDate'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderDetailsPage(orderId: orderId),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
