import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:qmed_employee/features/home/logic/data/models/home_model.dart';
import 'package:qmed_employee/features/home/logic/data/repositories/home_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {

  final HomeRepository homeRepository;
  HomeBloc(this.homeRepository) : super(HomeInitial()) {
    on<GetPatients>(
      (event, emit) async {
        emit(HomeLoading());
        try {
          final List<HomeModel> response =
              await homeRepository.getPatients(event.search);
          emit(HomeSuccess(response));
        } on DioError catch (e) {
          emit(HomeFailure(e.response!));
        }
      },
    );
  }
}
