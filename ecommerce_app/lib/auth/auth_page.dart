import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../bottom_nav_controller.dart';
import '../auth/login_or_register_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const BottomNavController();
          } else {
            return const LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}
