import 'package:qmed_employee/features/add_patient/logic/data/models/sector_model.dart';
import '../data/models/about_patient_model.dart';

abstract class AboutPatientState {}

class AboutPatientInitial extends AboutPatientState {}

class AboutPatientLoading extends AboutPatientState {}

class AboutPatientSuccess extends AboutPatientState {
  final PatientModel patient;
  AboutPatientSuccess(this.patient);
}

class AboutPatientError extends AboutPatientState {
  final String message;
  AboutPatientError(this.message);
}

class AboutPatientFailure extends AboutPatientState {
  final String error;
  AboutPatientFailure(this.error);
}

class SectorsLoaded extends AboutPatientState {
  final List<SectorModel> sectors;
  SectorsLoaded(this.sectors);
}

class SectorsLoadFailed extends AboutPatientState {
  final String error;
  SectorsLoadFailed(this.error);
}