import 'dart:convert';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:todo/AppBars/AddTodoAppBar.dart';
import 'package:todo/HomePage.dart';
import 'package:todo/ProfilePage.dart';
import 'package:todo/TodoModel.dart';

class AddTodoPage extends StatefulWidget {
  final List<TodoModel> todos;

  AddTodoPage({required this.todos});

  @override
  _AddTodoPageState createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  String _selectedPriority = 'Medium';
  DateTime? _selectedDate;
  bool _isSubmitting = false;

  Future<void> _addTodo() async {
    setState(() {
      _isSubmitting = true;
    });

    final url = Uri.parse('https://todo-node-api-3.onrender.com/todo/add');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "title": _titleController.text,
        "dueDate": _selectedDate != null
            ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
            : null,
        "priority": _selectedPriority,
        "description": _descriptionController.text,
        "userId": "64f8e59f2b7e970f3421d786"
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Todo added successfully!')),
      );

      _titleController.clear();
      _descriptionController.clear();
      setState(() {
        _selectedPriority = 'Medium';
        _selectedDate = null;
      });
    } else {
      debugPrint(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add todo.')),
      );
    }

    setState(() {
      _isSubmitting = false;
    });
  }

  Future<void> _pickDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AddTodoAppBar(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              _buildTextField(_titleController, 'Title'),
              SizedBox(height: 16),
              _buildDatePicker(context),
              SizedBox(height: 16),
              _buildPriorityDropdown(),
              SizedBox(height: 16),
              _buildTextField(_descriptionController, 'Description',
                  maxLines: 3),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _addTodo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff8687E7),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                ),
                child: _isSubmitting
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Add To-Do',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
              ),
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
          initialActiveIndex: 1,
          backgroundColor: Color(0xff8687E7),
          onTap: (int i) {
            if (i == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Homepage()),
              );
            }
            if (i == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfilePage(
                          todos: widget.todos,
                        )),
              );
            }
          },
        ));
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.teal[700]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.teal),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.teal[700]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.teal[800]!),
        ),
      ),
    );
  }

  Widget _buildPriorityDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedPriority,
      items: ['Low', 'Medium', 'High'].map((String priority) {
        return DropdownMenuItem<String>(
          value: priority,
          child: Text(priority),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedPriority = newValue!;
        });
      },
      decoration: InputDecoration(
        labelText: 'Priority',
        labelStyle: TextStyle(color: Colors.teal[700]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.teal),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.teal[700]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.teal[800]!),
        ),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return InkWell(
      onTap: () => _pickDueDate(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Due Date',
          labelStyle: TextStyle(color: Colors.teal[700]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.teal),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.teal[700]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.teal[800]!),
          ),
        ),
        child: Text(
          _selectedDate == null
              ? 'Select a date'
              : DateFormat('yyyy-MM-dd').format(_selectedDate!),
          style: TextStyle(color: Colors.black87),
        ),
      ),
    );
  }
}
