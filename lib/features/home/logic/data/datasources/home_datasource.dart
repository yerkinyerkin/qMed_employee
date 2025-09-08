import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:qmed_employee/core/dio_interceptor/dio_interceptor.dart';

abstract class HomeDataSource {
  Future<Response> getPatients(String search);
}

class HomeDatasourceImpl implements HomeDataSource {
  Dio get dio => DioInterceptor(Dio()).getDio;

  Box userId = Hive.box('userId');

  @override
  Future<Response> getPatients(String search) async {
    Response response = await dio.get(
      '/employee/${userId.get('userId')}/patients',
      queryParameters: {
        'search': search,
      }
    );

    return response;
  }
}
