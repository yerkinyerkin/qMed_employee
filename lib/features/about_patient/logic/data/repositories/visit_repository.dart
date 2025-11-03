import 'package:dio/dio.dart';
import '../models/visit_model.dart';
import '../datasources/visit_datasource.dart';

abstract class VisitRepository {
  Future<void> addHypertensionVisit(int patientId, Map<String, dynamic> visitData);
  Future<void> addHeartFailureVisit(int patientId, Map<String, dynamic> visitData);
  Future<void> addDiabetesVisit(int patientId, Map<String, dynamic> visitData);
  Future<List<Map<String, dynamic>>> getPatientVisits(int patientId, {int page = 1, int size = 100});
  Future<VisitModel> getVisitById(int visitId);
  Future<void> updateHypertensionVisit(int visitId, Map<String, dynamic> visitData);
  Future<void> updateHeartFailureVisit(int visitId, Map<String, dynamic> visitData);
  Future<void> updateDiabetesVisit(int visitId, Map<String, dynamic> visitData);
}

class VisitRepositoryImpl implements VisitRepository {
  final VisitDataSource dataSource;

  VisitRepositoryImpl(this.dataSource);

  @override
  Future<void> addHypertensionVisit(int patientId, Map<String, dynamic> visitData) async {
    try {
      await dataSource.addHypertensionVisit(patientId, visitData);
    } catch (e) {
      throw Exception('Failed to add hypertension visit: $e');
    }
  }

  @override
  Future<void> addHeartFailureVisit(int patientId, Map<String, dynamic> visitData) async {
    try {
      await dataSource.addHeartFailureVisit(patientId, visitData);
    } catch (e) {
      throw Exception('Failed to add heart failure visit: $e');
    }
  }

  @override
  Future<void> addDiabetesVisit(int patientId, Map<String, dynamic> visitData) async {
    try {
      await dataSource.addDiabetesVisit(patientId, visitData);
    } catch (e) {
      throw Exception('Failed to add diabetes visit: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getPatientVisits(int patientId, {int page = 1, int size = 100}) async {
    try {
      Response response = await dataSource.getPatientVisits(patientId, page: page, size: size);
      if (response.data is List) {
        return List<Map<String, dynamic>>.from(response.data);
      }
      return [];
    } catch (e) {
      throw Exception('Failed to get patient visits: $e');
    }
  }

  @override
  Future<VisitModel> getVisitById(int visitId) async {
    try {
      Response response = await dataSource.getVisitById(visitId);
      return VisitModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to get visit: $e');
    }
  }

  @override
  Future<void> updateHypertensionVisit(int visitId, Map<String, dynamic> visitData) async {
    try {
      await dataSource.updateHypertensionVisit(visitId, visitData);
    } catch (e) {
      throw Exception('Failed to update hypertension visit: $e');
    }
  }

  @override
  Future<void> updateHeartFailureVisit(int visitId, Map<String, dynamic> visitData) async {
    try {
      await dataSource.updateHeartFailureVisit(visitId, visitData);
    } catch (e) {
      throw Exception('Failed to update heart failure visit: $e');
    }
  }

  @override
  Future<void> updateDiabetesVisit(int visitId, Map<String, dynamic> visitData) async {
    try {
      await dataSource.updateDiabetesVisit(visitId, visitData);
    } catch (e) {
      throw Exception('Failed to update diabetes visit: $e');
    }
  }
}

