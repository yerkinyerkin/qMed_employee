import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'about_patient_event.dart';
import 'about_patient_state.dart';
import '../data/models/about_patient_model.dart';
import 'package:qmed_employee/features/add_patient/logic/data/models/sector_model.dart';
import '../data/repositories/about_patient_repository.dart';
import 'package:qmed_employee/features/profile/logic/data/repositories/profile_repository.dart';

class AboutPatientBloc extends Bloc<AboutPatientEvent, AboutPatientState> {
  final AboutPatientRepository repository;
  final ProfileRepository profileRepository;
  Box polyclinicBox = Hive.box('polyclinic');

  AboutPatientBloc(this.repository, this.profileRepository) : super(AboutPatientInitial()) {
    on<FetchPatientEvent>((event, emit) async {
      emit(AboutPatientLoading());
      try {
        final patient = await repository.getPatientById(event.userId);
        emit(AboutPatientSuccess(patient));
      } catch (e) {
        emit(AboutPatientError(e.toString()));
      }
    });

    on<AboutPatientButtonPressed>((event, emit) async {
      emit(AboutPatientLoading());
      try {
        await repository.AboutPatient(event.patient);
        emit(AboutPatientSuccess(event.patient));
      } catch (e) {
        emit(AboutPatientFailure(e.toString()));
      }
    });

    on<LoadSectors>((event, emit) async {
      try {
        await profileRepository.getProfile();
        
        final polyclinicId = polyclinicBox.get('polyclinic_id', defaultValue: 1);
        final polyclinicName = polyclinicBox.get('polyclinic_name', defaultValue: 'Unknown');
        
        print('Используем сохраненные данные поликлиники:');
        print('Polyclinic ID: $polyclinicId');
        print('Polyclinic Name: $polyclinicName');
        
        final sectors = await repository.getSectors(polyclinicId);
        emit(SectorsLoaded(sectors));
      } catch (e) {
        emit(SectorsLoadFailed(e.toString()));
      }
    });
  }
}