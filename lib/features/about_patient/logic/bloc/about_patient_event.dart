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