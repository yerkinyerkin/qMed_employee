import 'package:dio/dio.dart';
import 'package:qmed_employee/core/dio_interceptor/dio_interceptor.dart';

abstract class LoginDataSource {
  Future<Response> getToken(String username, String password);
}

class LoginDataSourceImpl implements LoginDataSource {
  Dio get dio => DioInterceptor(Dio()).getDio;

  @override
  Future<Response> getToken(String username, String password) async {
    Response response = await dio.post(
      '/login',
      data: {"username": username, "password": password},
    );

    return response;
  }
}
