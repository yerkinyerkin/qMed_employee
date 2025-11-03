import 'package:flutter_bloc/flutter_bloc.dart';
import 'visit_event.dart';
import 'visit_state.dart';
import '../data/repositories/visit_repository.dart';

class VisitBloc extends Bloc<VisitEvent, VisitState> {
  final VisitRepository repository;

  VisitBloc(this.repository) : super(VisitInitial()) {
    on<AddHypertensionVisitEvent>((event, emit) async {
      emit(VisitLoading());
      try {
        await repository.addHypertensionVisit(event.patientId, event.visitData);
        emit(VisitAddSuccess('Визит АГ успешно добавлен!'));
      } catch (e) {
        emit(VisitAddFailure(e.toString()));
      }
    });

    on<AddHeartFailureVisitEvent>((event, emit) async {
      emit(VisitLoading());
      try {
        await repository.addHeartFailureVisit(event.patientId, event.visitData);
        emit(VisitAddSuccess('Визит ХСН успешно добавлен!'));
      } catch (e) {
        emit(VisitAddFailure(e.toString()));
      }
    });

    on<AddDiabetesVisitEvent>((event, emit) async {
      emit(VisitLoading());
      try {
        await repository.addDiabetesVisit(event.patientId, event.visitData);
        emit(VisitAddSuccess('Визит СД успешно добавлен!'));
      } catch (e) {
        emit(VisitAddFailure(e.toString()));
      }
    });

    on<FetchPatientVisitsEvent>((event, emit) async {
      emit(VisitLoading());
      try {
        final visits = await repository.getPatientVisits(
          event.patientId,
          page: event.page,
          size: event.size,
        );
        emit(PatientVisitsLoaded(visits));
      } catch (e) {
        emit(PatientVisitsLoadFailure(e.toString()));
      }
    });

    on<FetchVisitByIdEvent>((event, emit) async {
      emit(VisitLoading());
      try {
        final visit = await repository.getVisitById(event.visitId);
        emit(VisitByIdLoaded(visit));
      } catch (e) {
        emit(VisitByIdLoadFailure(e.toString()));
      }
    });

    on<UpdateHypertensionVisitEvent>((event, emit) async {
      emit(VisitLoading());
      try {
        await repository.updateHypertensionVisit(event.visitId, event.visitData);
        emit(VisitUpdateSuccess('Визит АГ успешно обновлен!'));
      } catch (e) {
        emit(VisitUpdateFailure(e.toString()));
      }
    });

    on<UpdateHeartFailureVisitEvent>((event, emit) async {
      emit(VisitLoading());
      try {
        await repository.updateHeartFailureVisit(event.visitId, event.visitData);
        emit(VisitUpdateSuccess('Визит ХСН успешно обновлен!'));
      } catch (e) {
        emit(VisitUpdateFailure(e.toString()));
      }
    });

    on<UpdateDiabetesVisitEvent>((event, emit) async {
      emit(VisitLoading());
      try {
        await repository.updateDiabetesVisit(event.visitId, event.visitData);
        emit(VisitUpdateSuccess('Визит СД успешно обновлен!'));
      } catch (e) {
        emit(VisitUpdateFailure(e.toString()));
      }
    });
  }
}

