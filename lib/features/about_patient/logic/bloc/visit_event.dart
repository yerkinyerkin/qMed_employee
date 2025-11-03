abstract class VisitEvent {}

class AddHypertensionVisitEvent extends VisitEvent {
  final int patientId;
  final Map<String, dynamic> visitData;

  AddHypertensionVisitEvent({
    required this.patientId,
    required this.visitData,
  });
}

class AddHeartFailureVisitEvent extends VisitEvent {
  final int patientId;
  final Map<String, dynamic> visitData;

  AddHeartFailureVisitEvent({
    required this.patientId,
    required this.visitData,
  });
}

class AddDiabetesVisitEvent extends VisitEvent {
  final int patientId;
  final Map<String, dynamic> visitData;

  AddDiabetesVisitEvent({
    required this.patientId,
    required this.visitData,
  });
}

class FetchPatientVisitsEvent extends VisitEvent {
  final int patientId;
  final int page;
  final int size;

  FetchPatientVisitsEvent({
    required this.patientId,
    this.page = 1,
    this.size = 100,
  });
}

class FetchVisitByIdEvent extends VisitEvent {
  final int visitId;

  FetchVisitByIdEvent({required this.visitId});
}

class UpdateHypertensionVisitEvent extends VisitEvent {
  final int visitId;
  final Map<String, dynamic> visitData;

  UpdateHypertensionVisitEvent({
    required this.visitId,
    required this.visitData,
  });
}

class UpdateHeartFailureVisitEvent extends VisitEvent {
  final int visitId;
  final Map<String, dynamic> visitData;

  UpdateHeartFailureVisitEvent({
    required this.visitId,
    required this.visitData,
  });
}

class UpdateDiabetesVisitEvent extends VisitEvent {
  final int visitId;
  final Map<String, dynamic> visitData;

  UpdateDiabetesVisitEvent({
    required this.visitId,
    required this.visitData,
  });
}

