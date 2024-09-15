import 'package:flutter/material.dart';

AppBar HomeAppBar() {
  return AppBar(
    automaticallyImplyLeading: false,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(
          Icons.menu,
          color: Colors.white,
          size: 42,
        ),
        Text(
          "To-Do",
          style: TextStyle(fontSize: 30, color: Colors.white),
        ),
        CircleAvatar(
          radius: 28,
          backgroundColor: Colors.blueAccent,
          child: CircleAvatar(
            radius: 26,
            backgroundImage:
                NetworkImage('https://i.pravatar.cc/150?u=ravi@gmail.com'),
            backgroundColor: Colors.white,
          ),
        ),
      ],
    ),
    backgroundColor: Colors.black,
  );
}
