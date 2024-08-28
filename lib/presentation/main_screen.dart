import 'package:blocprepare_1/presentation/feat/bloc/todo/todo_bloc.dart';
import 'package:blocprepare_1/presentation/feat/bloc/todo/todo_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/features/model/todo.dart';
import 'feat/bloc/todo/todo_state.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<TodoBloc>(context).add(LoadTodos());

    return Scaffold(
      appBar: AppBar(
        title: const Text("To-do List"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showAddTodoDialog(context);
            },
          )
        ],
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          switch(state) {
            case TodoLoadProgress():
              return const MainLoadScreen();
            case TodoLoadSuccess():
              return TodoList(state.todos);
            case TodoLoadFailure():
              return const FailureScreen();
            default:
              return const Center(child: Text("초기상태"),);
          }
        },
      ),
    );
  }

  void _showAddTodoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddTodoDialog(),
    );
  }
}

class AddTodoDialog extends StatefulWidget {
  const AddTodoDialog({super.key});

  @override
  AddTodoDialogState createState() => AddTodoDialogState();
}

class AddTodoDialogState extends State<AddTodoDialog> {
  final taskController = TextEditingController();
  String? selectedDate;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("To-Do 추가"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: taskController,
            decoration: const InputDecoration(labelText: "Task"),
          ),
          const SizedBox(height: 16,),
          Row(
            children: [
              Text(
                selectedDate != null
                    ? "마감일자: ${selectedDate!.toString().split(' ')[0]}"
                    : "마감일자 선택",
              ),
              IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      selectedDate = pickedDate.toString();
                    });
                  }
                },
              ),
            ],
          )
        ],
      ),
      actions: [
        TextButton(
          child: const Text("추가"),
          onPressed: () {
            final task = taskController.text;

            if (task.isNotEmpty) {
              final newTodo = Todo(
                task: task,
                isCompleted: false,
                createdDate: DateTime.now().toString(),
                dueDate: selectedDate,
              );
              BlocProvider.of<TodoBloc>(context).add(AddTodo(newTodo));
              Navigator.of(context).pop();
            }
          },
        ),
        TextButton(
          child: const Text("취소"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}

class MainLoadScreen extends StatelessWidget {
  const MainLoadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class TodoList extends StatelessWidget {
  final List<Todo> todos;

  const TodoList(this.todos, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return ListTile(
          title: Text(todo.task),
          trailing: Checkbox(
            value: todo.isCompleted,
            onChanged: (bool? newValue) {
              BlocProvider.of<TodoBloc>(context).add(UpdateTodo(
                Todo(
                  id: todo.id,
                  task: todo.task,
                  isCompleted: newValue ?? false,
                  createdDate: todo.createdDate,
                  dueDate: todo.dueDate,
                ),
              ));
            },
          ),
          onLongPress: () {
            BlocProvider.of<TodoBloc>(context).add(DeleteTodo(todo));
          },
        );
      },
    );
  }
}

class FailureScreen extends StatelessWidget {
  const FailureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('로드 실패!'));
  }
}
