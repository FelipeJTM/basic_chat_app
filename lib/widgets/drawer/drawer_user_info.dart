import 'package:flutter/material.dart';

class DrawerUserInfo extends StatelessWidget {
  const DrawerUserInfo({super.key, required this.displayName});
  final String displayName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(Icons.account_circle, size: 150, color: Colors.grey[700]),
        const SizedBox(height: 15),
        Text(
          displayName,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
