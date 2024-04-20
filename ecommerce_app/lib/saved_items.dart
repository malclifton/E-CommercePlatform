import 'package:flutter/material.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text("Saved Items"),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
    );
  }
}
