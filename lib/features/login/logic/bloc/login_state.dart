part of 'login_bloc.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final LoginModel response;

  LoginSuccess(this.response);
}

class LoginFailure extends LoginState {
  final Response response;

  LoginFailure(this.response);
}
