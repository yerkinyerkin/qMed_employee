import 'package:dio/dio.dart';
import 'package:qmed_employee/core/dio_interceptor/dio_interceptor.dart';

abstract class HomeDataSource {
  Future<Response> getPatients({
    required String search,
    required int page,
    required int size,
  });
}

class HomeDatasourceImpl implements HomeDataSource {
  Dio get dio => DioInterceptor(Dio()).getDio;

  @override
  Future<Response> getPatients({
    required String search,
    required int page,
    required int size,
  }) async {
    final response = await dio.get(
      '/polyclinic/${9}/patients', // TODO: replace 9 with actual id if needed
      queryParameters: {
        'search': search,
        'page': page,
        'size': size,
      },
    );
    return response;
  }
}
