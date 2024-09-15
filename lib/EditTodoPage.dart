import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo/HomePage.dart';

class EditTodoPage extends StatefulWidget {
  final String id;
  final String title;
  final String dueDate;
  final String priority;
  final String description;

  EditTodoPage({
    required this.id,
    required this.title,
    required this.dueDate,
    required this.priority,
    required this.description,
  });

  @override
  _EditTodoPageState createState() => _EditTodoPageState();
}

class _EditTodoPageState extends State<EditTodoPage> {
  late TextEditingController _titleController;
  late TextEditingController _dueDateController;
  late TextEditingController _descriptionController;

  bool _isEditing = false;
  String _selectedPriority = 'Medium';

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _dueDateController = TextEditingController(text: widget.dueDate);
    _descriptionController = TextEditingController(text: widget.description);
    _selectedPriority = widget.priority;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dueDateController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _updateTodo() async {
    final url = Uri.parse(
        'https://todo-node-api-3.onrender.com/todo/update/${widget.id}');
    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "title": _titleController.text,
        "dueDate": _dueDateController.text,
        "priority": _selectedPriority,
        "description": _descriptionController.text,
        "completed": false
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Todo updated successfully!')),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Homepage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update todo.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Edit To-Do'),
          centerTitle: true,
          backgroundColor: Color(0xff8687E7)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildTextField(_titleController, 'Title'),
            SizedBox(height: 16),
            _buildTextField(_dueDateController, 'Due Date'),
            SizedBox(height: 16),
            _buildPriorityDropdown(),
            SizedBox(height: 16),
            _buildTextField(_descriptionController, 'Description', maxLines: 3),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _isEditing
                  ? _updateTodo
                  : () {
                      setState(() {
                        _isEditing = true;
                      });
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _isEditing ? Colors.orange[800] : Color(0xff8687E7),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
              ),
              child: Text(
                _isEditing ? 'Save' : 'Edit',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {int maxLines = 1}) {
    return TextField(
      controller: controller,
      enabled: _isEditing,
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
      onChanged: _isEditing
          ? (String? newValue) {
              setState(() {
                _selectedPriority = newValue!;
              });
            }
          : null,
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
}
