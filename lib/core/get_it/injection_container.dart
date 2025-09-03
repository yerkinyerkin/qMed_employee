import 'package:get_it/get_it.dart';
import 'package:qmed_employee/features/login/logic/bloc/login_bloc.dart';
import 'package:qmed_employee/features/login/logic/data/datasources/login_datasource.dart';
import 'package:qmed_employee/features/login/logic/data/repositories/login_repository.dart';

var sl = GetIt.instance;

void initGetIt() async {
  sl.registerFactory<LoginBloc>(() => LoginBloc(sl()));

  sl.registerLazySingleton<LoginRepository>(() => LoginRepositoryImpl(sl()));

  sl.registerLazySingleton<LoginDataSource>(() => LoginDataSourceImpl());
}
