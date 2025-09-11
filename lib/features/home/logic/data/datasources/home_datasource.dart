import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:qmed_employee/core/dio_interceptor/dio_interceptor.dart';

abstract class HomeDataSource {
  Future<Response> getPatients(int? polyclinicId,{
    required String search,
    required int page,
    required int size,
  });

  Future<Response> getProfile();
}

class HomeDatasourceImpl implements HomeDataSource {
  Dio get dio => DioInterceptor(Dio()).getDio;

   Box userId = Hive.box('userId');

  @override
  Future<Response> getPatients(int? polyclinicId,{
    required String search,
    required int page,
    required int size,
  }) async {
    final response = await dio.get(
      '/polyclinic/$polyclinicId/patients', 
      queryParameters: {
        'search': search,
        'page': page,
        'size': size,
      },
    );
    return response;
  }

  @override
  Future<Response> getProfile() async {
    Response response = await dio.get(
      '/employee/${userId.get('userId')}'
    );
    
    return response;
  }
}
