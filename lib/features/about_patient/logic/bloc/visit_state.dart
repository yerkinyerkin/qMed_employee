import '../data/models/visit_model.dart';

abstract class VisitState {}

class VisitInitial extends VisitState {}

class VisitLoading extends VisitState {}

class VisitAddSuccess extends VisitState {
  final String message;
  VisitAddSuccess(this.message);
}

class VisitAddFailure extends VisitState {
  final String error;
  VisitAddFailure(this.error);
}

class VisitUpdateSuccess extends VisitState {
  final String message;
  VisitUpdateSuccess(this.message);
}

class VisitUpdateFailure extends VisitState {
  final String error;
  VisitUpdateFailure(this.error);
}

class PatientVisitsLoaded extends VisitState {
  final List<Map<String, dynamic>> visits;
  PatientVisitsLoaded(this.visits);
}

class PatientVisitsLoadFailure extends VisitState {
  final String error;
  PatientVisitsLoadFailure(this.error);
}

class VisitByIdLoaded extends VisitState {
  final VisitModel visit;
  VisitByIdLoaded(this.visit);
}

class VisitByIdLoadFailure extends VisitState {
  final String error;
  VisitByIdLoadFailure(this.error);
}

