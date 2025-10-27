import 'package:get_it/get_it.dart';
import 'package:qmed_employee/features/add_patient/logic/bloc/add_patient_bloc.dart';
import 'package:qmed_employee/features/add_patient/logic/data/datasources/add_patient_datasource.dart';
import 'package:qmed_employee/features/add_patient/logic/data/repositories/add_patient_repository.dart';
import 'package:qmed_employee/features/about_patient/logic/bloc/about_patient_bloc.dart';
import 'package:qmed_employee/features/about_patient/logic/data/datasources/about_patient_datasource.dart';
import 'package:qmed_employee/features/about_patient/logic/data/repositories/about_patient_repository.dart';
import 'package:qmed_employee/features/home/logic/bloc/home_bloc.dart';
import 'package:qmed_employee/features/home/logic/data/datasources/home_datasource.dart';
import 'package:qmed_employee/features/home/logic/data/repositories/home_repository.dart';
import 'package:qmed_employee/features/login/logic/bloc/login_bloc.dart';
import 'package:qmed_employee/features/login/logic/data/datasources/login_datasource.dart';
import 'package:qmed_employee/features/login/logic/data/repositories/login_repository.dart';
import 'package:qmed_employee/features/profile/logic/bloc/profile_bloc.dart';
import 'package:qmed_employee/features/profile/logic/data/datasources/profile_datasource.dart';
import 'package:qmed_employee/features/profile/logic/data/repositories/profile_repository.dart';

var sl = GetIt.instance;

void initGetIt() async {

  sl.registerFactory<AddPatientBloc>(() => AddPatientBloc(sl(), sl()));
  
  sl.registerLazySingleton<AddPatientRepository>(() => AddPatientRepositoryImpl(sl()));
  
  sl.registerLazySingleton<AddPatientDataSource>(() => AddPatientDataSourceImpl());
  
  sl.registerFactory<LoginBloc>(() => LoginBloc(sl()));

  sl.registerLazySingleton<LoginRepository>(() => LoginRepositoryImpl(sl()));

  sl.registerLazySingleton<LoginDataSource>(() => LoginDataSourceImpl());

  sl.registerFactory<ProfileBloc>(() => ProfileBloc(sl()));

  sl.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl(sl()));

  sl.registerLazySingleton<ProfileDataSource>(() => ProfileDataSourceImpl());

  sl.registerFactory<HomeBloc>(() => HomeBloc(sl(),sl()));

  sl.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(sl(),sl()));

  sl.registerLazySingleton<HomeDataSource>(() => HomeDatasourceImpl());

  // About Patient
  sl.registerLazySingleton<AboutPatientDataSource>(() => AboutPatientDataSourceImpl());

  sl.registerLazySingleton<AboutPatientRepository>(() => AboutPatientRepositoryImpl(sl()));

  sl.registerFactory<AboutPatientBloc>(() => AboutPatientBloc(sl(), sl()));
}
