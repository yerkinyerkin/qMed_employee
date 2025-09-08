import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:qmed_employee/core/const/color_styles.dart';
import 'package:qmed_employee/core/get_it/injection_container.dart';
import 'package:qmed_employee/features/login/screens/login_screen.dart';
import 'package:qmed_employee/features/profile/logic/bloc/profile_bloc.dart';
import 'package:qmed_employee/features/profile/screens/faq/screens/faq_screen.dart';
import 'package:qmed_employee/features/profile/screens/my_profile/screens/my_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isOn = false;

  Future<void> _logout(BuildContext context) async {
    var tokenBox = Hive.box('token');
    await tokenBox.delete('token');

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen()
      ),
      (route) => false,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyles.backgroundColor,
      appBar: AppBar(
        backgroundColor: ColorStyles.primaryColor,
        title: Text('Профиль',style: GoogleFonts.montserrat(fontSize: 17,
        color: ColorStyles.whiteColor,fontWeight: FontWeight.w500,
        ),
      ),
      ),
      body: SafeArea(
        child: BlocProvider(
          create: (context) => sl<ProfileBloc>()..add(GetProfile()),
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if(state is ProfileLoading){
                return Center(child: const CircularProgressIndicator());
              }
              if(state is ProfileSuccess){
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                    children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: ColorStyles.whiteColor,
                        ),
                        child: Column(
                          children: [
                            Row(
                               mainAxisAlignment: MainAxisAlignment.start,
                               children: [
                                Text('${state.response.lastName} ${state.response.firstName}',
                                 style: GoogleFonts.montserrat(fontSize: 13,fontWeight: FontWeight.w500,color: ColorStyles.primaryColor),),
                              ],
                             ),
                             Row(
                               mainAxisAlignment: MainAxisAlignment.start,
                               children: [
                                 Text('${state.response.middleName}',
                                 style: GoogleFonts.montserrat(fontSize: 13,fontWeight: FontWeight.w500,color: ColorStyles.primaryColor),),
                               ],
                            ),
                          ],
                        ),
              ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context,
                              MaterialPageRoute(builder: (context)=>MyProfileScreen(response: state.response),),);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: ColorStyles.whiteColor,
                            
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Личные данные',
                                      style: GoogleFonts.montserrat(fontSize: 13,color: ColorStyles.blackColor,fontWeight: FontWeight.w500),),
                                       Text('Просмотреть личные данные',
                                      style: GoogleFonts.montserrat(fontSize: 11,color: ColorStyles.blackColor,fontWeight: FontWeight.w400),),
                                    ],
                                  ),
                                  Icon(Icons.arrow_forward_ios_outlined,color: ColorStyles.primaryColor,size: 16,)
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: ColorStyles.whiteColor,

                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Политика конфиденциальности',
                                    style: GoogleFonts.montserrat(fontSize: 13,color: ColorStyles.blackColor,fontWeight: FontWeight.w500),),
                                     Text('Нажмите для ознакомления',
                                    style: GoogleFonts.montserrat(fontSize: 11,color: ColorStyles.blackColor,fontWeight: FontWeight.w400),),
                                  ],
                                ),
                                Icon(Icons.arrow_forward_ios_outlined,color: ColorStyles.primaryColor,size: 16,)
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => FaqScreen()));
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: ColorStyles.whiteColor,
                            
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Часто задаваемые вопросы',
                                      style: GoogleFonts.montserrat(fontSize: 13,color: ColorStyles.blackColor,fontWeight: FontWeight.w500),),
                                       Text('Нажмите для ознакомления',
                                      style: GoogleFonts.montserrat(fontSize: 11,color: ColorStyles.blackColor,fontWeight: FontWeight.w400),),
                                    ],
                                  ),
                                  Icon(Icons.arrow_forward_ios_outlined,color: ColorStyles.primaryColor,size: 16,)
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: ColorStyles.whiteColor,

                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Смена языка',
                                    style: GoogleFonts.montserrat(fontSize: 13,color: ColorStyles.blackColor,fontWeight: FontWeight.w500),),
                                     Text('Русский язык',
                                    style: GoogleFonts.montserrat(fontSize: 11,color: ColorStyles.blackColor,fontWeight: FontWeight.w400),),
                                  ],
                                ),
                                Icon(Icons.arrow_forward_ios_outlined,color: ColorStyles.primaryColor,size: 16,)
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: ColorStyles.whiteColor,

                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Смена темы',
                                    style: GoogleFonts.montserrat(fontSize: 13,color: ColorStyles.blackColor,fontWeight: FontWeight.w500),),
                                     Text('Светлая',
                                    style: GoogleFonts.montserrat(fontSize: 11,color: ColorStyles.blackColor,fontWeight: FontWeight.w400),),
                                  ],
                                ),
                                Icon(Icons.arrow_forward_ios_outlined,color: ColorStyles.primaryColor,size: 16,)
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: ColorStyles.whiteColor,

                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Уведомления',
                                    style: GoogleFonts.montserrat(fontSize: 13,color: ColorStyles.blackColor,fontWeight: FontWeight.w500),),
                                     Text('Настройте уведомления приложения',
                                    style: GoogleFonts.montserrat(fontSize: 11,color: ColorStyles.blackColor,fontWeight: FontWeight.w400),),
                                  ],
                                ),
                                Switch(
                                  value: isOn,
                                  onChanged: (value) {
                                    setState(() {
                                      isOn = value;
                                    });
                                  },
                                  activeColor: Colors.white,                 // цвет кружка (вкл)
                                  activeTrackColor: const Color(0xFFA3763F), // коричневый фон
                                  inactiveThumbColor: Colors.white,          // цвет кружка (выкл)
                                  inactiveTrackColor: Colors.grey.shade300,  // серый фон
                                ),
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                      ],
                    ),
                    GestureDetector(
                      onTap: (){
                        _logout(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 20),
                        child: Container(
                         padding: const EdgeInsets.all(12),
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(12),
                          color: ColorStyles.whiteColor,
                          border: Border.all(color: Colors.red,width: 1)
                         ),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text('Выйти из аккаунта',
                                 style: GoogleFonts.montserrat(fontSize: 13,color: Colors.red,fontWeight: FontWeight.w500),),
                                  Text('Нажмите, чтобы выйти',
                                 style: GoogleFonts.montserrat(fontSize: 11,color: Colors.red,fontWeight: FontWeight.w400),),
                               ],
                             ),
                             Icon(Icons.arrow_forward_ios_outlined,color: Colors.red,size: 16,)
                           ],
                         ),
                                          ),
                      ),
                    ),

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
