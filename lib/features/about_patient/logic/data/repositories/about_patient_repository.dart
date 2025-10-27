import 'package:dio/dio.dart';
import '../models/about_patient_model.dart';
import 'package:qmed_employee/features/add_patient/logic/data/models/sector_model.dart';
import '../datasources/about_patient_datasource.dart';

abstract class AboutPatientRepository {
  Future<void> AboutPatient(PatientModel patient);
  Future<List<SectorModel>> getSectors(int polyclinicId);
  Future<PatientModel> getPatientById(int userId);
}

class AboutPatientRepositoryImpl implements AboutPatientRepository {
  final AboutPatientDataSource dataSource;
  
  AboutPatientRepositoryImpl(this.dataSource);
  
  @override
  Future<void> AboutPatient(PatientModel patient) async {
    try {
      Response response = await dataSource.AboutPatient(patient);
    } catch (e) {
      throw Exception('Failed to About patient: $e');
    }
  }

  @override
  Future<List<SectorModel>> getSectors(int polyclinicId) async {
    try {
      return await dataSource.getSectors(polyclinicId);
    } catch (e) {
      throw Exception('Failed to load sectors: $e');
    }
  }

  @override
  Future<PatientModel> getPatientById(int userId) async {
    try {
      Response response = await dataSource.getPatientById(userId);
      return PatientModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to get patient: $e');
    }
  }
}

