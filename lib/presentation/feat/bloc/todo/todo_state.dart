import '../../../../domain/features/model/todo.dart';

abstract class TodoState {}

class TodoInitial extends TodoState {}

class TodoLoadProgress extends TodoState {}

class TodoLoadSuccess extends TodoState {
  final List<Todo> todos;
  TodoLoadSuccess(this.todos);
}

class TodoLoadFailure extends TodoState {}