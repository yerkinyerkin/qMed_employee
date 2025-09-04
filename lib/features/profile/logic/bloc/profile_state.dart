part of 'profile_bloc.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final ProfileModel response;

  ProfileSuccess(this.response);
}

class ProfileFailure extends ProfileState {
  final Response response;

  ProfileFailure(this.response);
}
