import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qmed_employee/features/home/logic/data/models/home_model.dart';
import 'package:qmed_employee/features/home/logic/data/repositories/home_repository.dart';
import 'package:qmed_employee/features/profile/logic/data/models/profile_model.dart';
import 'package:qmed_employee/features/profile/logic/data/repositories/profile_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository homeRepository;
  final ProfileRepository profileRepository;

  static const int _pageSize = 20;
  int _page = 1;            // 1-based
  int _totalPages = 1;
  String _search = '';
  List<Data> _items = [];

  HomeBloc(this.homeRepository,this.profileRepository) : super(HomeInitial()) {
    on<GetPatients>(_onGetPatients);
    on<GetNextPatients>(_onGetNextPatients);
  }

  Future<void> _onGetPatients(GetPatients event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      _search = event.search;
      _page = 1;

      final ProfileModel profile =
              await profileRepository.getProfile();

      final HomeModel res = await homeRepository.getPatients(
        profile.polyclinic?.polyclinicId ?? 1,
        search: _search,
        page: _page,
        size: _pageSize,
      );

      _totalPages = res.total ?? 1;                 // <- ensure model exposes totalPages
      _items = List<Data>.from(res.data ?? const []);

      emit(HomeSuccess(
        profile,
        _items,
        page: _page,
        totalPages: _totalPages,
        isLoadingMore: false,
      ));
    } on DioException catch (e) {
      emit(HomeFailure(e.response));
    }
  }

  Future<void> _onGetNextPatients(GetNextPatients event, Emitter<HomeState> emit) async {
    final current = state;
    if (current is! HomeSuccess) return;
    if (!current.hasMore || current.isLoadingMore) return;

    emit(current.copyWith(isLoadingMore: true));

    try {
      final ProfileModel profile =
              await profileRepository.getProfile();
            

      final nextPage = current.page + 1; // ✅ +1 page
      final HomeModel res = await homeRepository.getPatients(
        profile.polyclinic?.polyclinicId ?? 1,
        search: _search,
        page: nextPage,
        size: _pageSize,
      );

      final newItems = List<Data>.from(res.data ?? const []);
      _items = [...current.response, ...newItems];
      _page = nextPage;
      _totalPages = res.total ?? current.totalPages;

      emit(HomeSuccess(
        profile,
        _items,
        page: _page,
        totalPages: _totalPages,
        isLoadingMore: false,
      ));
    } on DioException {
      emit((state as HomeSuccess).copyWith(isLoadingMore: false));
    }
  }
}
