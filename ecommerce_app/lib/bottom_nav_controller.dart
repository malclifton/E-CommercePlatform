// ignore_for_file: library_private_types_in_public_api

import 'package:ecommerce_app/pages/catalog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/constants/colors.dart';
import 'package:ecommerce_app/pages/shopping_cart.dart';
import 'package:ecommerce_app/pages/favorite.dart';
import 'package:ecommerce_app/pages/home.dart';
import 'package:ecommerce_app/pages/profile.dart';

class BottomNavController extends StatefulWidget {
  const BottomNavController({super.key});

  @override
  _BottomNavControllerState createState() => _BottomNavControllerState();
}

class _BottomNavControllerState extends State<BottomNavController> {
  final _pages = [
    Profile(),
    Favorite(),
    Home(),
    Catalog(),
    ShoppingCart(),
  ];
  var _currentIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 5,
        selectedItemColor: AppColors.prime,
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        selectedLabelStyle:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.face),
            label: ("Person"),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline), label: ("Favourite")),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: ("Home"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: ("Catalog"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: ("Cart"),
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            if (kDebugMode) {
              print(_currentIndex);
            }
          });
        },
      ),
      body: _pages[_currentIndex],
    );
  }
}
