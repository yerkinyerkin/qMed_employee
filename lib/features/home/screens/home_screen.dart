import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qmed_employee/core/const/color_styles.dart';
import 'package:qmed_employee/core/get_it/injection_container.dart';
import 'package:qmed_employee/features/home/logic/bloc/home_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyles.backgroundColor,
      appBar: AppBar(
        backgroundColor: ColorStyles.primaryColor,
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
                        child: ListView.builder(
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: state.response.length,
                        itemBuilder: (BuildContext context, int index){
                          return Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: ColorStyles.whiteColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          constraints: const BoxConstraints(minWidth: 40,minHeight: 40),
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12),
                                            color: const Color.fromARGB(255, 230, 229, 229),
                                          ),
                                          child: Text('${state.response[index].lastName.toString().substring(0,1)}${state.response[index].firstName.toString().substring(0,1)}',
                                          style: GoogleFonts.montserrat(fontSize: 16,color: ColorStyles.blackColor,fontWeight: FontWeight.w500),),
                                        ),
                                        const SizedBox(width: 8),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('${state.response[index].lastName} ${state.response[index].firstName}',
                                            style: GoogleFonts.montserrat(fontSize: 14,color: ColorStyles.blackColor,fontWeight: FontWeight.w500),),
                                            Text('ИИН: ${state.response[index].iin}',
                                            style: GoogleFonts.montserrat(fontSize: 12,color: ColorStyles.greyColor,fontWeight: FontWeight.w400),),
                                          ],
                                        )
                                      ],
                                    ),
                                    // SizedBox(
                                    //   width: 30,
                                    //   child: ListView.builder(
                                    //     itemCount: state.response[index].diseases?.length,
                                    //     physics: const NeverScrollableScrollPhysics(),
                                    //     shrinkWrap: true,
                                    //     itemBuilder: (BuildContext context, int indexindex){
                                    //     return Container(
                                    //       padding: const EdgeInsets.all(4),
                                    //       decoration: BoxDecoration(
                                    //         borderRadius: BorderRadius.circular(8),
                                    //         color: const Color.fromARGB(255, 230, 229, 229),
                                    //       ),
                                    //       child: Text('${state.response[index].diseases?[indexindex].name}',
                                    //       style: GoogleFonts.montserrat(fontSize: 12,color: ColorStyles.blackColor,fontWeight: FontWeight.w500),),
                                    //     );
                                    //   },),
                                    // ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                          );
                        },
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
