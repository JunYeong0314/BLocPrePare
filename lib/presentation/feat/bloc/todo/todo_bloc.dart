import 'package:bloc/bloc.dart';
import 'package:blocprepare_1/domain/features/db/todo_data_repository.dart';
import 'package:blocprepare_1/presentation/feat/bloc/todo/todo_event.dart';
import 'package:blocprepare_1/presentation/feat/bloc/todo/todo_state.dart';
import 'package:flutter/cupertino.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoDataRepository _todoDataRepository;

  TodoBloc(this._todoDataRepository) : super(TodoInitial()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodo>(_onAddTodo);
    on<UpdateTodo>(_onUpdateTodo);
    on<DeleteTodo>(_onDeleteTodo);
  }

  Future<void> _onLoadTodos(LoadTodos event, Emitter<TodoState> emit) async {
    emit(TodoLoadProgress());
    try {
      final todos = await _todoDataRepository.getTodos();
      emit(TodoLoadSuccess(todos));
    } catch (_) {
      emit(TodoLoadFailure());
    }
  }

  Future<void> _onAddTodo(AddTodo event, Emitter<TodoState> emit) async {
    try {
      await _todoDataRepository.addTodo(event.todo);
      add(LoadTodos()); // Refresh the list
    } catch (e) {
      debugPrint("에러사항:$e");
      emit(TodoLoadFailure());
    }
  }

  Future<void> _onUpdateTodo(UpdateTodo event, Emitter<TodoState> emit) async {
    try {
      await _todoDataRepository.updateTodo(event.todo);
      add(LoadTodos()); // Refresh the list
    } catch (_) {
      emit(TodoLoadFailure());
    }
  }

  Future<void> _onDeleteTodo(DeleteTodo event, Emitter<TodoState> emit) async {
    if (event.todo.id == null) {
      emit(TodoLoadFailure());
      return;
    }

    try {
      await _todoDataRepository.deleteTodo(event.todo.id!);
      add(LoadTodos()); // Refresh the list
    } catch (_) {
      emit(TodoLoadFailure());
    }
  }
}
