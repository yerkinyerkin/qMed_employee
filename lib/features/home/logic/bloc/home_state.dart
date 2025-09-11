part of 'home_bloc.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  ProfileModel? profile;
  final List<Data> response; // accumulated items
  final int page;            // current page (1-based)
  final int totalPages;      // from API
  final bool isLoadingMore;

  bool get hasMore => page < totalPages;

  HomeSuccess(
    this.profile,
    this.response, {
    required this.page,
    required this.totalPages,
    this.isLoadingMore = false,
  });

  HomeSuccess copyWith({
    ProfileModel? profile,
    List<Data>? response,
    int? page,
    int? totalPages,
    bool? isLoadingMore,
  }) {
    return HomeSuccess(
      profile,
      response ?? this.response,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class HomeFailure extends HomeState {
  final Response? error;
  HomeFailure(this.error);
}
