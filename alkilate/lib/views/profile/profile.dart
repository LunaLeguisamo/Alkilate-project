import 'package:flutter/material.dart';
import 'package:alkilate/services/auth.dart';
import 'package:alkilate/views/login/login.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().userStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('loading');
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('error'),
          );
        } else if (snapshot.hasData) {
          return const Text('profile');
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
