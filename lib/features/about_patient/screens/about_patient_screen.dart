import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:qmed_employee/core/common/snackbar_service.dart';
import 'package:qmed_employee/core/get_it/injection_container.dart';
import 'package:qmed_employee/features/about_patient/logic/bloc/about_patient_bloc.dart';
import 'package:qmed_employee/features/about_patient/logic/bloc/about_patient_event.dart';
import 'package:qmed_employee/features/about_patient/logic/bloc/about_patient_state.dart';
import 'package:qmed_employee/features/about_patient/screens/visits_screen.dart';
import 'package:qmed_employee/features/about_patient/screens/edit_patient_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qmed_employee/features/about_patient/widgets/add_text_field.dart';
import 'package:qmed_employee/features/about_patient/widgets/delete_patient_modal.dart';
import 'package:qmed_employee/core/const/color_styles.dart';



Future<void> _makePhoneCall(String phoneNumber, BuildContext context) async {
  if (phoneNumber.isEmpty) {
    SnackbarService.showError(context, 'Номер телефона не указан');
    return;
  }
  
  final cleanPhoneNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
  final phoneUrl = Uri.parse('tel:$cleanPhoneNumber');
  
  try {
    if (await canLaunchUrl(phoneUrl)) {
      await launchUrl(phoneUrl);
    } else {
      SnackbarService.showError(context, 'На этом устройстве звонки не поддерживаются');
    }
  } catch (e) {
    SnackbarService.showError(context, 'Не удалось совершить звонок');
  }
}

class ModalBottomSheetApp extends StatefulWidget {
  final int patientId;
  final AboutPatientBloc bloc;
  const ModalBottomSheetApp({super.key, required this.patientId, required this.bloc});

  @override
  State<ModalBottomSheetApp> createState() => _ModalBottomSheetAppState();
}

class _ModalBottomSheetAppState extends State<ModalBottomSheetApp> {
  final TextEditingController _hospitalDateController = TextEditingController();
  final TextEditingController _causeDiagnozController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Очищаем поля при открытии модального окна
    _hospitalDateController.clear();
    _causeDiagnozController.clear();
  }

  @override
  void dispose() {
    // Очищаем контроллеры при закрытии
    _hospitalDateController.dispose();
    _causeDiagnozController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) {
          _hospitalDateController.clear();
          _causeDiagnozController.clear();
        }
      },
      child: Container(
        height: 400,
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
        children:[
           Row(
                children: [
                  Text('Дата госпитализации',style: GoogleFonts.montserrat(fontSize: 12,fontWeight: FontWeight.w600,color: ColorStyles.blackColor),)
                ],
              ),
              const SizedBox(height: 4),
              AddTextField(
                      controller: _hospitalDateController,
                      hintText: 'ДД.ММ.ГГГГ',
                      readOnly: true,
                      onTap: () async {
                        final now = DateTime.now();
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: now,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          final dd = picked.day.toString().padLeft(2, '0');
                          final mm = picked.month.toString().padLeft(2, '0');
                          final yyyy = picked.year.toString();
                          _hospitalDateController.text = '$dd.$mm.$yyyy';
                        }
                      },
                    ),
                    const SizedBox(height:10),
                    Row(
                children: [
                  Text('Причина (диагноз)',style: GoogleFonts.montserrat(fontSize: 12,fontWeight: FontWeight.w600,color: ColorStyles.blackColor),)
                ],
              ),
              const SizedBox(height: 4),
              AddTextField(
                      controller: _causeDiagnozController,
                      hintText: 'Причина (диагноз)',
             onTap: () async {
             },
            ),


            const SizedBox(height:10),
            SizedBox(
  width: 200,
  height: 35,
  child: TextButton(
    onPressed: () {
      final dateText = _hospitalDateController.text.trim();
      final reasonText = _causeDiagnozController.text.trim();
      if (dateText.isEmpty || reasonText.isEmpty) {
        SnackbarService.showError(context, 'Укажите дату и причину');
        return;
      }
      // Парсим дату
      final parts = dateText.split('.');
      if (parts.length != 3) {
        SnackbarService.showError(context, 'Введите дату в формате ДД.ММ.ГГГГ');
        return;
      }
      
      int? day, month, year;
      try {
        day = int.parse(parts[0].trim());
        month = int.parse(parts[1].trim());
        year = int.parse(parts[2].trim());
      } catch (e) {
        SnackbarService.showError(context, 'Введите дату в формате ДД.ММ.ГГГГ');
        return;
      }
      
      // Проверяем валидность диапазонов
      if (day < 1 || day > 31 || month < 1 || month > 12 || year < 2000 || year > 2100) {
        SnackbarService.showError(context, 'Введите корректную дату');
        return;
      }
      
      // Создаем дату с временем 00:00:00 в UTC
      try {
        final date = DateTime.utc(year, month, day, 0, 0, 0);
        
        if (date.year != year || date.month != month || date.day != day) {
          SnackbarService.showError(context, 'Неверная дата (например, 31 февраля)');
          return;
        }
        

        String createdAt = date.toIso8601String();
        if (createdAt.contains('.')) {
          createdAt = createdAt.substring(0, createdAt.indexOf('.')) + 'Z';
        }
        
        // Используем BLoC, переданный через параметр
        widget.bloc.add(HospitalizePatientEvent(patientId: widget.patientId, createdAt: createdAt, reason: reasonText));
        
        // Очищаем поля перед закрытием
        _hospitalDateController.clear();
        _causeDiagnozController.clear();
        Navigator.pop(context);
      } catch (dateError) {
        SnackbarService.showError(context, 'Ошибка при создании даты: ${dateError.toString()}');
      }
    },
    style: TextButton.styleFrom(
      backgroundColor: const Color(0xFF1C6BA4),
      foregroundColor: Colors.white,
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    ),
    child: const Text("Сохранить"), 
  ),
)

        ]
      ),
      ),
    );
  }
}


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
        body: MultiBlocListener(
          listeners: [
            BlocListener<AboutPatientBloc, AboutPatientState>(
              listenWhen: (previous, current) => current is PatientDeleteSuccess || current is PatientDeleteFailure,
              listener: (context, state) {
                if (state is PatientDeleteSuccess) {
                  SnackbarService.showSuccess(context, state.message);
                  Navigator.of(context).popUntil((route) => route.isFirst);
                } else if (state is PatientDeleteFailure) {
                  SnackbarService.showError(context, state.error);
                  Navigator.pop(context);
                }
              },
            ),
            BlocListener<AboutPatientBloc, AboutPatientState>(
              listenWhen: (previous, current) {
                // Отслеживаем успешную госпитализацию: переход от PatientHospitalizeLoading к AboutPatientSuccess
                return (previous is PatientHospitalizeLoading && current is AboutPatientSuccess) ||
                       current is PatientHospitalizeFailure;
              },
              listener: (context, state) {
                if (state is AboutPatientSuccess) {
                  // Показываем сообщение об успехе после успешной госпитализации
                  SnackbarService.showSuccess(context, 'Госпитализация сохранена');
                } else if (state is PatientHospitalizeFailure) {
                  SnackbarService.showError(context, state.error);
                }
              },
            ),
          ],
          child: BlocBuilder<AboutPatientBloc, AboutPatientState>(
          builder: (context, state) {
            if (state is AboutPatientLoading || state is PatientDeleteLoading || state is PatientHospitalizeLoading) {
              return Center(child: CircularProgressIndicator());
            }
            
            if (state is AboutPatientError || state is PatientDeleteFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 60, color: Colors.red),
                    SizedBox(height: 16),
                    Text(state is AboutPatientError 
                        ? 'Ошибка: ${state.message}' 
                        : 'Ошибка: ${(state as PatientDeleteFailure).error}'),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      child: const Text('Вернуться на главную'),
                    ),
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
                        final bloc = context.read<AboutPatientBloc>();
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => BlocProvider.value(
                            value: bloc,
                            child: ModalBottomSheetApp(patientId: patient.userId ?? 0, bloc: bloc),
                          ),
                        );
                      },
                    ),
                    _buildActionButton(
                      context,
                      icon: Icons.phone,
                      text: 'Связаться',
                      onTap: () {
    final phoneNumber = patient.phoneNumber ?? patient.relativePhoneNumber ?? '';
    _makePhoneCall(phoneNumber, context);
  },
                    ),
                    _buildActionButton(
                      context,
                      icon: Icons.edit,
                      text: 'Редактирование',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EditPatientScreen(patientId: patient.userId ?? 0)),
                        );
                      },
                    ),
                    _buildActionButton(
                      context,
                      icon: Icons.delete,
                      text: 'Удалить пациента',
                      onTap: () {
                        final bloc = context.read<AboutPatientBloc>();
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (context) => DeletePatientModal(
                            patientId: patient.userId ?? 0,
                            bloc: bloc,
                          ),
                        );
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