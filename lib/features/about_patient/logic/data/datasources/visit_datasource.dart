import 'package:dio/dio.dart';
import 'package:qmed_employee/core/dio_interceptor/dio_interceptor.dart';

abstract class VisitDataSource {
  Future<Response> addHypertensionVisit(int patientId, Map<String, dynamic> visitData);
  Future<Response> addHeartFailureVisit(int patientId, Map<String, dynamic> visitData);
  Future<Response> addDiabetesVisit(int patientId, Map<String, dynamic> visitData);
  Future<Response> getPatientVisits(int patientId, {int page = 1, int size = 100});
  Future<Response> getVisitById(int visitId);
  Future<Response> updateHypertensionVisit(int visitId, Map<String, dynamic> visitData);
  Future<Response> updateHeartFailureVisit(int visitId, Map<String, dynamic> visitData);
  Future<Response> updateDiabetesVisit(int visitId, Map<String, dynamic> visitData);
}

class VisitDataSourceImpl implements VisitDataSource {
  Dio get dio => DioInterceptor(Dio()).getDio;

  @override
  Future<Response> addHypertensionVisit(int patientId, Map<String, dynamic> visitData) async {
    try {
      final response = await dio.post(
        '/patient/$patientId/visit-hypertension',
        data: visitData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Server error: ${e.response?.statusCode} - ${e.response?.data}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<Response> addHeartFailureVisit(int patientId, Map<String, dynamic> visitData) async {
    try {
      final response = await dio.post(
        '/patient/$patientId/visit-heart-failure',
        data: visitData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Server error: ${e.response?.statusCode} - ${e.response?.data}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<Response> addDiabetesVisit(int patientId, Map<String, dynamic> visitData) async {
    try {
      final response = await dio.post(
        '/patient/$patientId/visit-diabetes',
        data: visitData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Server error: ${e.response?.statusCode} - ${e.response?.data}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<Response> getPatientVisits(int patientId, {int page = 1, int size = 100}) async {
    try {
      final response = await dio.get(
        '/patient/$patientId/visits',
        queryParameters: {
          'page': page,
          'size': size,
        },
      );
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Server error: ${e.response?.statusCode} - ${e.response?.data}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<Response> getVisitById(int visitId) async {
    try {
      final response = await dio.get('/visit/$visitId');
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Server error: ${e.response?.statusCode} - ${e.response?.data}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<Response> updateHypertensionVisit(int visitId, Map<String, dynamic> visitData) async {
    try {
      final response = await dio.put(
        '/visit/$visitId/hypertension',
        data: visitData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Server error: ${e.response?.statusCode} - ${e.response?.data}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<Response> updateHeartFailureVisit(int visitId, Map<String, dynamic> visitData) async {
    try {
      final response = await dio.put(
        '/visit/$visitId/heart-failure',
        data: visitData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Server error: ${e.response?.statusCode} - ${e.response?.data}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<Response> updateDiabetesVisit(int visitId, Map<String, dynamic> visitData) async {
    try {
      final response = await dio.put(
        '/visit/$visitId/diabetes',
        data: visitData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Server error: ${e.response?.statusCode} - ${e.response?.data}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}

