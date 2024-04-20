// reach this page from the nav bar on the homepage
//user can upload images and information on item
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
    );
  }
}
