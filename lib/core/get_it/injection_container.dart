import 'package:get_it/get_it.dart';
import 'package:qmed_employee/features/login/logic/bloc/login_bloc.dart';
import 'package:qmed_employee/features/login/logic/data/datasources/login_datasource.dart';
import 'package:qmed_employee/features/login/logic/data/repositories/login_repository.dart';
import 'package:qmed_employee/features/profile/logic/bloc/profile_bloc.dart';
import 'package:qmed_employee/features/profile/logic/data/datasources/profile_datasource.dart';
import 'package:qmed_employee/features/profile/logic/data/repositories/profile_repository.dart';

var sl = GetIt.instance;

void initGetIt() async {
  sl.registerFactory<LoginBloc>(() => LoginBloc(sl()));

  sl.registerLazySingleton<LoginRepository>(() => LoginRepositoryImpl(sl()));

  sl.registerLazySingleton<LoginDataSource>(() => LoginDataSourceImpl());

  sl.registerFactory<ProfileBloc>(() => ProfileBloc(sl()));

  sl.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl(sl()));

  sl.registerLazySingleton<ProfileDataSource>(() => ProfileDataSourceImpl());
}
