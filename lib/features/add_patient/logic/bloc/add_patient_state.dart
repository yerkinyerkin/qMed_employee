import '../data/models/sector_model.dart';

abstract class AddPatientState {}

class AddPatientInitial extends AddPatientState {}
class AddPatientLoading extends AddPatientState {}
class AddPatientSuccess extends AddPatientState {}
class AddPatientFailure extends AddPatientState {
  final String error;
  AddPatientFailure(this.error);
}

class SectorsLoaded extends AddPatientState {
  final List<SectorModel> sectors;
  SectorsLoaded(this.sectors);
}

class SectorsLoadFailed extends AddPatientState {
  final String error;
  SectorsLoadFailed(this.error);
}