import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:qmed_employee/core/bottomnavbar/bottom_navbar.dart';
import 'package:qmed_employee/core/const/color_styles.dart';
import 'package:qmed_employee/core/get_it/injection_container.dart';
import 'package:qmed_employee/core/hive/hive_init.dart';
import 'package:qmed_employee/features/home/logic/bloc/home_bloc.dart';
import 'package:qmed_employee/features/login/logic/bloc/login_bloc.dart';
import 'package:qmed_employee/features/login/screens/login_screen.dart';
import 'package:qmed_employee/features/profile/logic/bloc/profile_bloc.dart';

Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await initHiveBoxes();
  initGetIt();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    Box token = Hive.box('token');
    return MultiBlocProvider(
      providers:[
        BlocProvider<LoginBloc>(
          create: (_) => sl(),
        ),
        BlocProvider<ProfileBloc>(
          create: (_) => sl(),
        ),
        BlocProvider<HomeBloc>(
          create: (_) => sl(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: ColorStyles.primaryColor),
        ),
        home: token.get('token') == null
              ? const LoginScreen()
              : BottomNavBar(index: 1),
      ),
    );
  }
}

