import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String email;

  ProfileHeader({required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.blueAccent,
          child: CircleAvatar(
            radius: 48,
            backgroundImage:
                NetworkImage('https://i.pravatar.cc/150?u=${email}'),
            backgroundColor: Colors.white,
          ),
        ),
        SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            SizedBox(height: 4),
            Text(
              email,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}
