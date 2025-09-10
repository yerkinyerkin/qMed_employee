import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qmed_employee/core/const/color_styles.dart';
import 'package:qmed_employee/core/get_it/injection_container.dart';
import 'package:qmed_employee/features/home/logic/bloc/home_bloc.dart';
import 'package:qmed_employee/features/notification/screens/notification_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyles.backgroundColor,
      appBar: AppBar(
        backgroundColor: ColorStyles.primaryColor,
        actions: [
          GestureDetector(
            onTap: (){
              Navigator.push(context,
              MaterialPageRoute(builder: (context) => NotificationScreen()));
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Icon(Icons.notifications_none,
              color: ColorStyles.whiteColor,
              size: 23,),
            ),
          )
        ],
        title: Text('Главная',style: GoogleFonts.montserrat(fontSize: 17,
        color: ColorStyles.whiteColor,fontWeight: FontWeight.w500,
        ),
      ),
      ),
      body: SafeArea(
        child: BlocProvider(
          create: (context) => sl<HomeBloc>()..add(GetPatients('')),
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if(state is HomeLoading){
                return Center(child: const CircularProgressIndicator());
              }
              if(state is HomeSuccess){
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      CupertinoSearchTextField(
                        controller: _controller,
                        backgroundColor: const Color.fromARGB(255, 239, 237, 237),
                        style: GoogleFonts.montserrat(fontSize: 13),
                        placeholder: "Search...",
                        onSubmitted: (value) {
                          context.read<HomeBloc>().add(
                            GetPatients(_controller.text.trim()),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: state.response.data?.length,
                          itemBuilder: (BuildContext context, int index){
                            return state.response.data?[index].zone == 'green' ? Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('${state.response.data?[index].lastName} ${state.response.data?[index].firstName}',
                                      style: GoogleFonts.montserrat(fontSize: 14,color: ColorStyles.blackColor,fontWeight: FontWeight.w600),),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Text('ИИН: ',
                                          style: GoogleFonts.montserrat(fontSize: 11,color: ColorStyles.greyColor,fontWeight: FontWeight.w400),),
                                           Text('${state.response.data?[index].iin}',
                                          style: GoogleFonts.montserrat(fontSize: 11,color: ColorStyles.greyColor,fontWeight: FontWeight.w400),),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text('Заболевания: ',style: GoogleFonts.montserrat(fontSize: 11,color: ColorStyles.greyColor,fontWeight: FontWeight.w400),),
                                          Text(state.response.data?[index].diseases?.map(
                                            (disease) => disease.name ?? "").join(', ') ?? '',
                                          style: GoogleFonts.montserrat(fontSize: 11,color: ColorStyles.blackColor,fontWeight: FontWeight.w500),),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                              ],
                            ) : SizedBox();
                          },
                                              ),
                          ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: state.response.data?.length,
                          itemBuilder: (BuildContext context, int index){
                            return Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: ColorStyles.whiteColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('${state.response.data?[index].lastName} ${state.response.data?[index].firstName}',
                                      style: GoogleFonts.montserrat(fontSize: 14,color: ColorStyles.blackColor,fontWeight: FontWeight.w600),),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Text('ИИН: ',
                                          style: GoogleFonts.montserrat(fontSize: 11,color: ColorStyles.greyColor,fontWeight: FontWeight.w400),),
                                           Text('${state.response.data?[index].iin}',
                                          style: GoogleFonts.montserrat(fontSize: 11,color: ColorStyles.greyColor,fontWeight: FontWeight.w400),),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text('Заболевания: ',style: GoogleFonts.montserrat(fontSize: 11,color: ColorStyles.greyColor,fontWeight: FontWeight.w400),),
                                          Text(state.response.data?[index].diseases?.map(
                                            (disease) => disease.name ?? "").join(', ') ?? '',
                                          style: GoogleFonts.montserrat(fontSize: 11,color: ColorStyles.blackColor,fontWeight: FontWeight.w500),),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                              ],
                            );
                          },
                                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
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
