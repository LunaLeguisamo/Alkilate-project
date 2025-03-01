// ignore_for_file: use_build_context_synchronously

import 'package:alkilate/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:alkilate/services/services.dart';
import 'package:alkilate/views/login/login.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().userStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        } else if (snapshot.hasError) {
          return Center(
            child: ErrorMessage(
                message: 'Failed to load user data: ${snapshot.error}'),
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
                return _buildProfile(user);
              } else {
                return Center(
                  child: ErrorMessage(
                      message: 'No user found in Firestore. Check database'),
                );
              }
            },
          );
        } else {
          return const LoginScreen();
        }
      },
    );
  }

  Widget _buildProfile(User user) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ProfileBanner(user: user),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Wrap(
                    children: [
                      Text(
                        'Hello, ',
                        style: TextStyle(
                          fontSize: 39,
                          color: Color(0xFF7F7F7F),
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        user.name,
                        style: TextStyle(
                          fontSize: 39,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 30),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildIconButton(
                        'assets/images/My-listing.png',
                        () => Navigator.pushNamed(context, '/user-products'),
                      ),
                      _buildIconButton(
                        'assets/images/My-orders.png',
                        () => Navigator.pushNamed(context, '/user-orders'),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildIconButton('assets/images/Pending.png',
                          () => Navigator.pushNamed(context, '/pending')),
                      _buildIconButton('assets/images/Update-profile.png',
                          () => _showEditProfileDialog(context, user)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(String imagePath, VoidCallback onTap) {
    return Column(
      children: [
        InkWell(
          onTap: onTap, // Execute the provided function
          borderRadius: BorderRadius.circular(15),
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: SizedBox(
              width: 156.7,
              height: 226.3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showEditProfileDialog(BuildContext context, User user) {
    final TextEditingController nameController =
        TextEditingController(text: user.name);
    final TextEditingController emailController =
        TextEditingController(text: user.email);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Your Profile'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppFormField(
                  controller: nameController,
                  label: 'Name',
                  hint: 'Enter your name',
                  enabled: true,
                ),
                SizedBox(height: 10),
                AppFormField(
                  controller: emailController,
                  label: 'Email',
                  hint: 'Enter your email',
                  enabled: true,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _saveChanges(user, nameController.text, emailController.text);
                Navigator.of(context).pop(); // Close the dialog after saving
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _saveChanges(User user, String newName, String newEmail) {
    user.name = newName;
    user.email = newEmail;
    // Update user data in Firestore
    FirestoreService().updateUserData(user).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );
      setState(() {
        user.name = newName;
        user.email = newEmail;
      });
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $error')),
      );
    });
  }
}

class AppFormField extends StatelessWidget {
  const AppFormField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    required this.enabled,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      ),
    );
  }
}
