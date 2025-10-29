import 'package:dio/dio.dart';
import 'package:qmed_employee/core/dio_interceptor/dio_interceptor.dart';
import '../models/about_patient_model.dart';
import 'package:qmed_employee/features/add_patient/logic/data/models/sector_model.dart';

abstract class AboutPatientDataSource {
  Future<Response> AboutPatient(PatientModel patient);
  Future<List<SectorModel>> getSectors(int polyclinicId);
  Future<Response> getPatientById(int userId);
  Future<Response> updatePatient(int patientId, Map<String, dynamic> patientData);
  Future<Response> deletePatient(int patientId, int removalReasonId, {String? causeOfDeath});
  Future<Response> hospitalizePatient(int patientId, {required String createdAt, required String reason});
}

class AboutPatientDataSourceImpl implements AboutPatientDataSource {
  Dio get dio => DioInterceptor(Dio()).getDio;
  
  @override
  Future<Response> AboutPatient(PatientModel patient) async {
    try {
      final response = await dio.post(
        '/patient',
        data: patient.toJson(),
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
  Future<List<SectorModel>> getSectors(int polyclinicId) async {
    try {
      print('Запрашиваем участки для polyclinic ID: $polyclinicId');
      final response = await dio.get('/polyclinic/$polyclinicId/sectors');
      print('Получен ответ: ${response.statusCode}');
      print('Данные ответа: ${response.data}');
      
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => SectorModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load sectors: ${response.statusCode}');
      }
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
  Future<Response> getPatientById(int userId) async {
    try {
      print('Запрашиваем пациента с ID: $userId');
      final response = await dio.get('/patient/$userId');
      print('Получен ответ: ${response.statusCode}');
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
  Future<Response> updatePatient(int patientId, Map<String, dynamic> patientData) async {
    try {
      print('Обновляем пациента с ID: $patientId');
      print('Данные для обновления: $patientData');
      
      final response = await dio.put(
        '/patient/$patientId',
        data: patientData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      
      print('Пациент обновлен, статус: ${response.statusCode}');
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
  Future<Response> deletePatient(int patientId, int removalReasonId, {String? causeOfDeath}) async {
    try {
      print('Удаляем пациента с ID: $patientId');
      print('Причина удаления: $removalReasonId');
      print('Причина смерти: $causeOfDeath');
      
      final data = <String, dynamic>{
        'removal_reason_id': removalReasonId,
      };
      
      // Добавляем cause_of_death только если оно есть
      if (causeOfDeath != null && causeOfDeath.isNotEmpty) {
        data['cause_of_death'] = causeOfDeath;
      }
      
      print('Отправляем данные: $data');
      print('URL: /patient/$patientId/remove');
      
      final response = await dio.post(
        '/patient/$patientId/remove',
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      
      print('Пациент удален, статус: ${response.statusCode}');
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
  Future<Response> hospitalizePatient(int patientId, {required String createdAt, required String reason}) async {
    try {
      final data = <String, dynamic>{
        'created_at': createdAt,
        'reason': reason,
      };

      final response = await dio.post(
        '/patient/$patientId/hospitalize',
        data: data,
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