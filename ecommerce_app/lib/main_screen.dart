//Login page will send user to this screen
//create bottom nav bar (profile, saved, home, selling, buying)
//homepage will show....
// Recommended items, trending items (based on # of likes), last items viewed.
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'cart_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentTab = 2;
  List screens = const [
    Scaffold(),
    Scaffold(),
    HomeScreen(),
    CartScreen(),
    Scaffold()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            currentTab = 2;
          });
        },
        elevation: 0,
        shape: const CircleBorder(),
        backgroundColor: const Color(0xffc1121f),
        child: const Icon(
          Icons.home,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        height: 70,
        shape: const CircularNotchedRectangle(),
        notchMargin: 5,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () => setState(() {
                      currentTab = 0;
                    }),
                icon: Icon(
                  Icons.face,
                  color: currentTab == 0
                      ? Color(0xffc1121f)
                      : const Color(0xff669bbc),
                )),
            IconButton(
                onPressed: () => setState(() {
                      currentTab = 1;
                    }),
                icon: Icon(
                  Icons.favorite,
                  color: currentTab == 1
                      ? Color(0xffc1121f)
                      : const Color(0xff669bbc),
                )),
            IconButton(
                onPressed: () => setState(() {
                      currentTab = 3;
                    }),
                icon: Icon(
                  Icons.search,
                  color: currentTab == 3
                      ? const Color(0xffc1121f)
                      : const Color(0xff669bbc),
                )),
            IconButton(
                onPressed: () => setState(() {
                      currentTab = 4;
                    }),
                icon: Icon(
                  Icons.shopping_cart,
                  color: currentTab == 4
                      ? const Color(0xffc1121f)
                      : const Color(0xff669bbc),
                ))
          ],
        ),
      ),
      body: screens[currentTab],
    );
  }
}
