import '../data/models/about_patient_model.dart';
import 'package:qmed_employee/features/add_patient/logic/data/models/sector_model.dart';

abstract class AboutPatientEvent {}

class AboutPatientButtonPressed extends AboutPatientEvent {
  final PatientModel patient;
  
  AboutPatientButtonPressed(this.patient);
}

class LoadSectors extends AboutPatientEvent {}

class FetchPatientEvent extends AboutPatientEvent {
  final int userId;
  
  FetchPatientEvent({required this.userId});
}

class UpdatePatientEvent extends AboutPatientEvent {
  final int patientId;
  final Map<String, dynamic> patientData;
  
  UpdatePatientEvent({required this.patientId, required this.patientData});
}

class DeletePatientEvent extends AboutPatientEvent {
  final int patientId;
  final int removalReasonId;
  final String? causeOfDeath;
  
  DeletePatientEvent({
    required this.patientId,
    required this.removalReasonId,
    this.causeOfDeath,
  });
}

class HospitalizePatientEvent extends AboutPatientEvent {
  final int patientId;
  final String createdAt; // ISO8601
  final String reason;

  HospitalizePatientEvent({
    required this.patientId,
    required this.createdAt,
    required this.reason,
  });
}