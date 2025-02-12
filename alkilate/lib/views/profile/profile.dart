import 'package:alkilate/shared/shared.dart';
import 'package:alkilate/views/login/login.dart';
import 'package:flutter/material.dart';
import 'package:alkilate/services/services.dart';

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
          return FutureBuilder<User>(
            future: FirestoreService().getCurrentUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingScreen();
              } else if (snapshot.hasError) {
                return Center(
                  child: ErrorMessage(message: snapshot.error.toString()),
                );
              } else if (snapshot.hasData) {
                var user = snapshot.data!;

                return Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.deepPurple,
                    title: const Text('Profile'),
                  ),
                  body: GridView.count(
                    primary: false,
                    padding: const EdgeInsets.all(20.0),
                    crossAxisSpacing: 10.0,
                    crossAxisCount: 2,
                    children: [Text(user.name)],
                  ),
                  bottomNavigationBar: const BottomNavBar(),
                );
              } else {
                return const Text(
                    'No topics found in Firestore. Check database');
              }
            },
          );
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
