import 'package:dio/dio.dart';
import 'package:qmed_employee/features/login/logic/data/datasources/login_datasource.dart';
import 'package:qmed_employee/features/login/logic/data/models/login_model.dart';

abstract class LoginRepository {
  Future<LoginModel> getToken(String username, String password);
}

class LoginRepositoryImpl implements LoginRepository {
  final LoginDataSource loginDataSource;

  LoginRepositoryImpl(this.loginDataSource);

  @override
  Future<LoginModel> getToken(String username, String password) async {
    Response response = await loginDataSource.getToken(username, password);
    return LoginModel.fromJson(response.data);
  }
}
