import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qmed_employee/core/bottomnavbar/bottom_navbar.dart';
import 'package:qmed_employee/core/common/custom_button.dart';
import 'package:qmed_employee/core/common/custom_textfield.dart';
import 'package:qmed_employee/core/const/color_styles.dart';
import 'package:qmed_employee/features/login/logic/bloc/login_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool isHide = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyles.whiteColor,
      body: SafeArea(
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => BottomNavBar(index: 0)),
                (Route<dynamic> route) => false,
              );
            }
            if (state is LoginFailure) {
              showTopSnackBar(
                Overlay.of(context),
                CustomSnackBar.error(
                  message: state.response.toString(),
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 80),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/png/qmed_logo.png',
                      width: 160,
                      height: 60,
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Вход',
                      style: GoogleFonts.montserrat(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: ColorStyles.primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Логин',
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: ColorStyles.blackColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  hintText: 'Ваш логин',
                  controller: _loginController,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Пароль',
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: ColorStyles.blackColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  obscureText: isHide,
                  suffix: GestureDetector(
                    onTap: () {
                      setState(() {
                        isHide = !isHide;
                      });
                    },
                    child:
                        isHide == false
                            ? Icon(
                              Icons.visibility,
                              color: ColorStyles.primaryColor,
                              size: 20,
                            )
                            : Icon(
                              Icons.visibility_off,
                              color: ColorStyles.primaryColor,
                              size: 20,
                            ),
                  ),
                  hintText: 'Ваш пароль',
                  controller: _passwordController,
                ),
                const SizedBox(height: 30),
                BlocBuilder<LoginBloc, LoginState>(
                  builder: (context, state) {
                    return CustomButton(
                      text: state is LoginLoading ? 'Загрузка...'  :  'Войти',
                      onTap: state is LoginLoading ? (){} :  () {
                        context.read<LoginBloc>().add(
                          GetToken(
                            _loginController.text,
                            _passwordController.text,
                          ),
                        );
                      },
                      color: ColorStyles.primaryColor,
                      colorText: ColorStyles.whiteColor,
                    );
                  },
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Забыли пароль?',
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: ColorStyles.primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
