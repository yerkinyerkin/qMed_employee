import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'add_patient_event.dart';
import 'add_patient_state.dart';
import '../data/models/add_patient_model.dart';
import '../data/models/sector_model.dart';
import '../data/repositories/add_patient_repository.dart';
import '../../../profile/logic/data/repositories/profile_repository.dart';

class AddPatientBloc extends Bloc<AddPatientEvent, AddPatientState> {
  final AddPatientRepository repository;
  final ProfileRepository profileRepository;
  Box polyclinicBox = Hive.box('polyclinic');

  AddPatientBloc(this.repository, this.profileRepository) : super(AddPatientInitial()) {
    on<AddPatientButtonPressed>((event, emit) async {
      emit(AddPatientLoading());
      try {
        await repository.addPatient(event.patient);
        emit(AddPatientSuccess());
      } catch (e) {
        emit(AddPatientFailure(e.toString()));
      }
    });

    on<LoadSectors>((event, emit) async {
      try {
        // Сначала получаем профиль (это сохранит данные поликлиники в Hive)
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