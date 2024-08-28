class Todo {
  int? id;
  final String task;
  final bool isCompleted;
  final String createdDate;
  final String? dueDate;

  Todo({
    this.id,
    required this.task,
    required this.isCompleted,
    required this.createdDate,
    this.dueDate
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'task': task,
      'isCompleted': isCompleted,
      'createdDate': createdDate,
      'dueDate': dueDate
    };
  }
}