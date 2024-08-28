import 'package:blocprepare_1/domain/features/db/todo_data_repository.dart';
import 'package:blocprepare_1/presentation/feat/bloc/todo/todo_bloc.dart';
import 'package:blocprepare_1/presentation/locator/locator.dart';
import 'package:blocprepare_1/presentation/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  initLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoBloc(locator<TodoDataRepository>()),
      child: const MaterialApp(
        home: MainScreen(),
      ),
    );
  }
}