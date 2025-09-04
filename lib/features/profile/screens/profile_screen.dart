import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qmed_employee/core/const/color_styles.dart';
import 'package:qmed_employee/core/get_it/injection_container.dart';
import 'package:qmed_employee/features/profile/logic/bloc/profile_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyles.backgroundColor,
      body: SafeArea(
        child: BlocProvider(
          create: (context) => sl<ProfileBloc>()..add(GetProfile()),
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if(state is ProfileLoading){
                return const CircularProgressIndicator();
              }
              if(state is ProfileSuccess){
                return Column(
                  children: [
                    
                  ]
                );
              }
              return const Offstage();
            },
          ),
        ),
      ),
    );
  }
}
