import 'package:dio/dio.dart';
import '../models/add_patient_model.dart';
import '../models/sector_model.dart';
import '../datasources/add_patient_datasource.dart';

abstract class AddPatientRepository {
  Future<void> addPatient(PatientModel patient);
  Future<List<SectorModel>> getSectors(int polyclinicId);
}

class AddPatientRepositoryImpl implements AddPatientRepository {
  final AddPatientDataSource dataSource;
  
  AddPatientRepositoryImpl(this.dataSource);
  
  @override
  Future<void> addPatient(PatientModel patient) async {
    try {
      Response response = await dataSource.addPatient(patient);
    } catch (e) {
      throw Exception('Failed to add patient: $e');
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
}