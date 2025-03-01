import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final String message;
  final IconData icon;

  const ErrorMessage({
    super.key,
    this.message = 'Oops, something went wrong!',
    this.icon = Icons.error_outline_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.symmetric(
          vertical: 24,
          horizontal: 20,
        ),
        decoration: BoxDecoration(
          color: const Color.fromARGB(40, 255, 193, 7),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color.fromARGB(66, 255, 193, 7),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(101, 0, 0, 0),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 48,
              color: Colors.amber[800],
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.amber[900],
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please try again later',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: const Color.fromARGB(160, 255, 145, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
