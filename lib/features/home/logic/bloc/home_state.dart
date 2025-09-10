part of 'home_bloc.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final HomeModel response;

  HomeSuccess(this.response);
}

class HomeFailure extends HomeState {
  final Response response;

  HomeFailure(this.response);
}
