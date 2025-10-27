import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qmed_employee/core/get_it/injection_container.dart';
import 'package:qmed_employee/features/about_patient/logic/bloc/about_patient_bloc.dart';
import 'package:qmed_employee/features/about_patient/logic/bloc/about_patient_event.dart';
import 'package:qmed_employee/features/about_patient/logic/bloc/about_patient_state.dart';
import 'package:qmed_employee/features/about_patient/screens/visits_screen.dart';
import 'package:qmed_employee/features/about_patient/screens/edit_patient_screen.dart';


class AboutPatientScreen extends StatelessWidget {
  final int userId;
  
  const AboutPatientScreen({super.key, required this.userId});
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AboutPatientBloc>()
        ..add(FetchPatientEvent(userId: userId)),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Пациент', style: TextStyle(color: Colors.white)),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Color(0xFF1C6BA4),
        ),
        body: BlocBuilder<AboutPatientBloc, AboutPatientState>(
          builder: (context, state) {
            if (state is AboutPatientLoading) {
              return Center(child: CircularProgressIndicator());
            }
            
            if (state is AboutPatientError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 60, color: Colors.red),
                    SizedBox(height: 16),
                    Text('Ошибка: ${state.message}'),
                  ],
                ),
              );
            }
            
            if (state is AboutPatientSuccess) {
              final patient = state.patient;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 10),
                      child: Text(
                        '${patient.lastName ?? ''} ${patient.firstName ?? ''} ${patient.middleName ?? ''}'.trim(),
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        patient.iin ?? 'Нет данных',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 130,
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Color(0xFFECECEC),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Давление',
                                style: TextStyle(color: Colors.black, fontSize: 18),
                              ),
                              Text(
                                patient.bloodPressure ?? 'Неизвестный',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.person,
                            color: Colors.grey,
                            size: 70,
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Container(
                              width: 175,
                              height: 120,
                              padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFAF0DB),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Рост',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      '${patient.heightCm ?? '-'} см',
                                      style: TextStyle(
                                        color: Color(0xFFE09F1F),
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        Container(
                          width: 175,
                          height: 120,
                          padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5E1E9),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Вес',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  '${patient.weightKg ?? '-'} кг',
                                  style: TextStyle(
                                    color: Color(0xFFF73859),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    _buildActionButton(
                      context,
                      icon: Icons.list_alt,
                      text: 'Визиты',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => VisitsScreen()),
                        );
                      },
                    ),
                    _buildActionButton(
                      context,
                      icon: Icons.add_circle_outline,
                      text: 'Госпитализация',
                      onTap: () {
                        // TODO: Навигация к госпитализации
                      },
                    ),
                    _buildActionButton(
                      context,
                      icon: Icons.phone,
                      text: 'Связаться',
                      onTap: () {
                        // TODO: Позвонить пациенту
                      },
                    ),
                    _buildActionButton(
                      context,
                      icon: Icons.edit,
                      text: 'Редактирование',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EditPatientScreen()),
                        );
                      },
                    ),
                    _buildActionButton(
                      context,
                      icon: Icons.delete,
                      text: 'Удалить пациента',
                      onTap: () {
                        // TODO: Удалить пациента
                      },
                    ),
                  ],
                ),
              );
            }
            
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 53,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Color(0xFFE0E0E0), width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              child:Icon(
                icon,
                color: Color(0xFF4A7BA7),
                size: 24,
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}