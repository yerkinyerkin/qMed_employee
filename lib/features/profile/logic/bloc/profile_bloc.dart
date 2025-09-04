import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:qmed_employee/features/profile/logic/data/models/profile_model.dart';
import 'package:qmed_employee/features/profile/logic/data/repositories/profile_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {

  final ProfileRepository profileRepository;
  ProfileBloc(this.profileRepository) : super(ProfileInitial()) {
    on<GetProfile>(
      (event, emit) async {
        emit(ProfileLoading());
        try {
          final ProfileModel response =
              await profileRepository.getProfile();
          emit(ProfileSuccess(response));
        } on DioError catch (e) {
          emit(ProfileFailure(e.response!));
        }
      },
    );
  }
}
