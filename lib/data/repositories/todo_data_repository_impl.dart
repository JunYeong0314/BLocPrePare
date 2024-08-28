import 'package:blocprepare_1/domain/features/db/todo_data_repository.dart';
import 'package:blocprepare_1/domain/features/model/todo.dart';
import 'package:sqflite/sqflite.dart';
import '../db/database_helper.dart';

class TodoDataRepositoryImpl implements TodoDataRepository {
  final DatabaseHelper _databaseHelper;

  TodoDataRepositoryImpl(this._databaseHelper);

  @override
  Future<void> addTodo(Todo todo) async {
    final db = await _databaseHelper.database;

    await db?.insert(
      'todos',
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> deleteTodo(int id) async {
    final db = await _databaseHelper.database;

    await db?.delete(
      'todos',
      where: 'id = ?', // SQL 쿼리에서 id가 특정 값과 일치하는 행을 찾는 조건
      whereArgs: [id],
    );
  }

  @override
  Future<List<Todo>> getTodos() async {
    final db = await _databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db?.query('todos') ?? [];

    return List.generate(maps.length, (i) {
      return Todo(
        id: maps[i]['id'],
        task: maps[i]['task'],
        isCompleted: maps[i]['isCompleted'] == 1,
        createdDate: maps[i]['createdDate'],
        dueDate: maps[i]['dueDate']
      );
    });
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    final db = await _databaseHelper.database;

    await db?.update(
      'todos',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }
}