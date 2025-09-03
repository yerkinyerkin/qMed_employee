import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:qmed_employee/features/login/logic/data/models/login_model.dart';
import 'package:qmed_employee/features/login/logic/data/repositories/login_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  Box tokens = Hive.box('token');

  final LoginRepository loginRepository;
  LoginBloc(this.loginRepository) : super(LoginInitial()) {
    on<GetToken>(
      (event, emit) async {
        emit(LoginLoading());
        try {
          final LoginModel response =
              await loginRepository.getToken(event.username, event.password);
          tokens.put('token', response.token?? "");
          log(response.token?? "");
          emit(LoginSuccess(response));
        } on DioError catch (e) {
          emit(LoginFailure(e.response!));
        }
      },
    );
  }
}
