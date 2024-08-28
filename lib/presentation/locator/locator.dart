import 'package:blocprepare_1/data/db/database_helper.dart';
import 'package:blocprepare_1/data/repositories/todo_data_repository_impl.dart';
import 'package:blocprepare_1/domain/features/db/todo_data_repository.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

initLocator() {
  locator
      .registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());
  locator
      .registerLazySingleton<TodoDataRepository>(() => TodoDataRepositoryImpl(locator<DatabaseHelper>()));
}