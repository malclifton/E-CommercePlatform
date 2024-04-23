import 'package:ecommerce_app/auth/auth_page.dart';
import 'package:ecommerce_app/pages/order_processing.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user;
  String? username;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    fetchUserData();
  }

  void fetchUserData() async {
    DocumentSnapshot userData = await FirebaseFirestore.instance
        .collection('credentials')
        .doc(user?.uid)
        .get();

    setState(() {
      username = userData['userId'];
    });
  }

  void handleLogout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(builder: (context) => const AuthPage()),
    );
  }

  void handleUpdateUsername() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? newUsername = username;

        return AlertDialog(
          title: const Text('Update Username'),
          content: TextField(
            decoration: const InputDecoration(labelText: 'New Username'),
            onChanged: (value) {
              newUsername = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('credentials')
                    .doc(user?.uid)
                    .update({'userId': newUsername});

                setState(() {
                  username = newUsername;
                });

                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void handleOrderDetails() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const OrderHistoryPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => handleLogout(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Color.fromARGB(255, 200, 200, 200),
              child: Icon(
                Icons.person,
                size: 50,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              "Hello $username!",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: handleUpdateUsername,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black),
                foregroundColor: MaterialStateProperty.all(Colors.white),
                textStyle: MaterialStateProperty.all(
                    const TextStyle(fontSize: 16, color: Colors.white)),
                padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 12)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                )),
              ),
              child: const Text('Update Username'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: handleOrderDetails,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black),
                foregroundColor: MaterialStateProperty.all(Colors.white),
                textStyle: MaterialStateProperty.all(
                    const TextStyle(fontSize: 16, color: Colors.white)),
                padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 12)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                )),
              ),
              child: const Text('Check Order Details'),
            ),
          ],
        ),
      ),
    );
  }
}
