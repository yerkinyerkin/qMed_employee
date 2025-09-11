part of 'home_bloc.dart';

abstract class HomeEvent {}

class GetPatients extends HomeEvent {
  final String search;
  GetPatients(this.search);
}

class GetNextPatients extends HomeEvent {}
