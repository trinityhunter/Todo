class TodoModel {
  final String id;
  final String title;
  final String description;
  final String dueDate;
  final String priority;
  final bool completed;

  TodoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.completed,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? 'No Title',
      dueDate: json['dueDate'] ?? '',
      priority: json['priority'] ?? 'low',
      description: json['description'] ?? '',
      completed: json['completed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'priority': priority,
      'completed': completed,
    };
  }
}
