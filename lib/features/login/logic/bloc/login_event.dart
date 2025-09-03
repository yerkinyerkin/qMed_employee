part of 'login_bloc.dart';

abstract class LoginEvent {}

class GetToken extends LoginEvent {
  final String username;
  final String password;

  GetToken(this.username, this.password);
}
