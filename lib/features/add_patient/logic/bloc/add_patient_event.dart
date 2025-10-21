import '../data/models/add_patient_model.dart';
import '../data/models/sector_model.dart';

abstract class AddPatientEvent {}

class AddPatientButtonPressed extends AddPatientEvent {
  final PatientModel patient;
  
  AddPatientButtonPressed(this.patient);
}

class LoadSectors extends AddPatientEvent {}