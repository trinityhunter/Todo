import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:todo/AddToDoPage.dart';
import 'package:todo/AppBars/ProfileAppBar.dart';
import 'package:todo/HomePage.dart';
import 'package:todo/ProfileDetail.dart';
import 'package:todo/ProfileHeader.dart';
import 'package:todo/TodoModel.dart';

class ProfilePage extends StatefulWidget {
  final List<TodoModel> todos;

  ProfilePage({required this.todos});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic> userData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  void logout() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ProfileAppBar(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileHeader(name: "Raviraj", email: "ravi@gmail.com"),
              SizedBox(height: 20),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      ProfileDetail(title: 'Name', value: "Raviraj"),
                      Divider(),
                      ProfileDetail(title: 'Email', value: "ravi@gmail.com"),
                      Divider(),
                      ProfileDetail(
                          title: 'Total Tasks',
                          value: '${widget.todos.length}'),
                      Divider(),
                      ProfileDetail(title: 'Completed', value: '${3}'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(height: 10),
            ],
          ),
        ),
        bottomNavigationBar: ConvexAppBar(
          style: TabStyle.react,
          items: [
            TabItem(icon: Icons.home),
            TabItem(icon: Icons.add),
            TabItem(icon: Icons.person),
          ],
          initialActiveIndex: 2,
          backgroundColor: Color(0xff8687E7),
          onTap: (int i) {
            if (i == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Homepage()),
              );
            }
            if (i == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddTodoPage(todos: widget.todos)),
              );
            }
          },
        ));
  }
}
