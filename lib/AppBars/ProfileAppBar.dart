import 'package:flutter/material.dart';

AppBar ProfileAppBar() {
  return AppBar(
    centerTitle: true,
    title: Text('Profile'),
    // backgroundColor: Colors.blueAccent,
    backgroundColor: Color(0xff8687E7),
    automaticallyImplyLeading: false,
    actions: [
      IconButton(
        icon: Icon(Icons.logout),
        onPressed: () {},
      ),
    ],
  );
}
