import 'package:alkilate/services/models.dart';
import 'package:flutter/material.dart';

class ProfileBanner extends StatelessWidget {
  final User? user;

  const ProfileBanner({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Hero(
          tag: 'profile',
          child: Image.asset(
            'assets/images/profile-banner.png',
            height: 126,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(31.5, 71, 0, 0),
          child: CircleAvatar(
            radius: 48.5,
            backgroundImage: NetworkImage(user!.photoURL),
          ),
        ),
      ],
    );
  }
}
