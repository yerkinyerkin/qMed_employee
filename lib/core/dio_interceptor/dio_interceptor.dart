import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

class DioInterceptor {
  final Dio api;

  Dio get getDio => api;
  String? accessToken;

  final Box _storage = Hive.box('token');

  DioInterceptor(this.api) {
    accessToken = _storage.get("token");
    log("Token: $accessToken");
    api.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
      options.connectTimeout = const Duration(seconds: 30);
      options.receiveTimeout = const Duration(seconds: 30);
        options.headers['Accept'] = 'application/json';

      options.baseUrl = 'https://qmedbackprod.chickenkiller.com';
      if (accessToken != null) {
        options.headers['Authorization'] = 'Bearer $accessToken';
        options.headers['Accept'] = 'application/json';
      }
      return handler.next(options);
    }, 
   
    onError: (DioException error, handler) async {
      if (error.response?.statusCode == 422) {
       
      }
      return handler.next(error);
    }));
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return api.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }

  Future<bool> refreshToken() async {
    final token = await _storage.get('access');

    final response =
        await api.get('refresh', queryParameters: {'token': token});

    if (response.statusCode == 200) {
      log("SUCCESS");
      inspect(response.data);
      accessToken = response.data['data'];
      _storage.put('access', accessToken);
      return true;
    } else {
      log("FAILURE");
      // refresh token is wrong
      accessToken = null;
      _storage.clear();
      return false;
    }
  }
}