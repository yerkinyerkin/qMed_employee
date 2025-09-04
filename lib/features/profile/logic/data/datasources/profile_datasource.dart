import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:qmed_employee/core/dio_interceptor/dio_interceptor.dart';

abstract class ProfileDataSource {
  Future<Response> getProfile();
}

class ProfileDataSourceImpl implements ProfileDataSource {
  Dio get dio => DioInterceptor(Dio()).getDio;

  Box userId = Hive.box('userId');

  @override
  Future<Response> getProfile() async {
    Response response = await dio.get(
      '/employee/${userId.get('userId')}'
    );
    
    return response;
  }
}
