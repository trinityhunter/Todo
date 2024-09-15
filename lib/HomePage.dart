import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:todo/AddToDoPage.dart';
import 'package:todo/AppBars/HomePageAppBar.dart';
import 'package:todo/EditTodoPage.dart';
import 'package:todo/ProfilePage.dart';
import 'package:todo/TodoModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final String baseUrl = 'https://todo-node-api-3.onrender.com/todo';

  List<TodoModel> todos = [];

  int _selectedTabIndex = 0;

  Future<List<TodoModel>> getTodos() async {
    final response = await http.get(Uri.parse('$baseUrl/'));

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      // debugPrint(data[0]["_id"]);
      return data.map((todo) => TodoModel.fromJson(todo)).toList();
    } else {
      throw Exception('Failed to load todos');
    }
  }

  Future<void> deleteTodo(String id) async {
    debugPrint(id);

    final response = await http.delete(Uri.parse('$baseUrl/delete/$id'));

    if (response.statusCode == 200) {
      setState(() {
        todos.removeWhere((todo) => todo.id == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task deleted successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete task.')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchTodos();
  }

  fetchTodos() async {
    try {
      var fetchedTodos = await getTodos();
      debugPrint(fetchedTodos[0].id);
      setState(() {
        todos = fetchedTodos;
      });
    } catch (e) {
      print(e);
    }
  }

  Widget initialScreen() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("images/InitialPic.png"),
          Text(
            "What do you want to do today?",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          Text(
            "Tap + to add your tasks",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget dataScreen() {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditTodoPage(
                  id: todos[index].id,
                  title: todos[index].title,
                  dueDate: todos[index].dueDate,
                  priority: todos[index].priority,
                  description: todos[index].description,
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: todos[index].completed ? Colors.green[100] : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: todos[index].completed ? Colors.green : Colors.grey,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        todos[index].title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Due Date: ${todos[index].dueDate != null && todos[index].dueDate.length >= 10 ? todos[index].dueDate.substring(0, 10) : 'Invalid Date'}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      Row(
                        children: [
                          Icon(
                            _getPriorityIcon(todos[index].priority),
                            color: _getPriorityColor(todos[index].priority),
                            size: 20,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Priority: ${todos[index].priority}',
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Checkbox(
                  value: todos[index].completed,
                  onChanged: (bool? value) {},
                  activeColor: Colors.green,
                  checkColor: Colors.white,
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    deleteTodo(todos[index].id);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _getPriorityIcon(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Icons.priority_high;
      case 'medium':
        return Icons.warning;
      case 'low':
        return Icons.low_priority;
      default:
        return Icons.info;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  Widget _HomeWidget() {
    return todos.isEmpty ? initialScreen() : dataScreen();
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = [
      _HomeWidget(),
      AddTodoPage(todos: todos),
      ProfilePage(todos: todos)
    ];
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: HomeAppBar(),
      body: _pages[_selectedTabIndex],
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.react,
        items: [
          TabItem(icon: Icons.home),
          TabItem(icon: Icons.add),
          TabItem(icon: Icons.person),
        ],
        initialActiveIndex: 0,
        backgroundColor: Color(0xff8687E7),
        onTap: (int i) {
          if (i == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddTodoPage(
                        todos: todos,
                      )),
            );
          }
          if (i == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfilePage(
                        todos: todos,
                      )),
            );
          }
        },
      ),
    );
  }
}
