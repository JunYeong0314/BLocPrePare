import '../model/todo.dart';

abstract class TodoDataRepository {
  Future<List<Todo>> getTodos();
  Future<void> updateTodo(Todo todo);
  Future<void> addTodo(Todo todo);
  Future<void> deleteTodo(int id);
}