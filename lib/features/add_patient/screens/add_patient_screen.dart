import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qmed_employee/core/const/color_styles.dart';
import 'package:qmed_employee/core/common/snackbar_service.dart';
import 'package:qmed_employee/features/add_patient/widgets/add_text_field.dart';
import 'package:qmed_employee/features/add_patient/logic/bloc/add_patient_bloc.dart';
import 'package:qmed_employee/features/add_patient/logic/bloc/add_patient_event.dart';
import 'package:qmed_employee/features/add_patient/logic/bloc/add_patient_state.dart';
import 'package:qmed_employee/features/add_patient/logic/data/models/add_patient_model.dart';
import 'package:qmed_employee/features/add_patient/logic/data/models/sector_model.dart';
class AddPatientScreen extends StatefulWidget {
  const AddPatientScreen({super.key});

  @override
  State<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  String? selectedGender;
  String? selectedNoezologya;
  String? smokingStatus;
  SectorModel? selectedSector;
  List<SectorModel> sectors = [];
  double? bmi;
  final _uchastokController = TextEditingController();
  final _surnameController = TextEditingController();
  final _nameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _iinController = TextEditingController();
  final _birthController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _noezologyaController = TextEditingController();
  final _genderController = TextEditingController();
  final _addressController = TextEditingController();
  final _mailController = TextEditingController();
  final _contactController = TextEditingController();
  final _arterialdavlenie = TextEditingController();
  final _heartbeat = TextEditingController();
  final _levelsugar = TextEditingController();
  final _lastBPDate = TextEditingController();
  final _lastSelfManagementDate = TextEditingController();
  final _confidenceLevel = TextEditingController();
  final _lastConfidenceDate = TextEditingController();
  final _hba1cValue = TextEditingController();
  final _hba1cDate = TextEditingController();
  final _ldlValue = TextEditingController();
  final _ldlDate = TextEditingController();
  final _footExamDate = TextEditingController();
  final _retinopathyDate = TextEditingController();
  final _sakDate = TextEditingController();
  final _smokingStatusAssessmentDate = TextEditingController();
  final _smokingCessationCounselingDate = TextEditingController();
  final _cholesterolValue = TextEditingController();
  final _cholesterolDate = TextEditingController();
  final _riskLevel = TextEditingController();
  
  // Хроническая сердечная недостаточность
  final _efValue = TextEditingController();
  final _echoDate = TextEditingController();
  final _hospitalizationDate = TextEditingController();
  final _fluVaccinationDate = TextEditingController();
  final _egfrValue = TextEditingController();

  String? selectedDisease;
  
  // Артериальная гипертензия
  String? hypertensionRiskLevel;
  
  // Хроническая сердечная недостаточность
  String? nyhaClass;
  bool? takesBetaBlockers;
  bool? takesACEInhibitor;
  bool? takesAldosteroneAntagonists;
  bool? hasEchoECGStudy;
  bool? hasLeftVentricularDysfunction;
  
  // Сахарный диабет
  bool? hasCVD;
  bool? hasRetinopathy;
  bool? takesStatin;
  @override
  void initState() {
    super.initState();
    context.read<AddPatientBloc>().add(LoadSectors());
  }
  String _convertDateFormat(String date) {
    if (date.isEmpty) return '';
    try {
      final parts = date.split('.');
      if (parts.length == 3) {
        final day = parts[0].padLeft(2, '0');
        final month = parts[1].padLeft(2, '0');
        final year = parts[2];
        return '$year-$month-$day';
      }
    } catch (e) {
      print('Ошибка конвертации даты: $e');
    }
    return date; 
  }

  String _convertToISODate(String date) {
    if (date.isEmpty) return '';
    final convertedDate = _convertDateFormat(date);
    return '${convertedDate}T00:00:00Z';
  }

  @override
  void dispose() {
    _uchastokController.dispose();
    _surnameController.dispose();
    _nameController.dispose();
    _middleNameController.dispose();
    _iinController.dispose();
    _birthController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _addressController.dispose();
    _contactController.dispose();
    _arterialdavlenie.dispose();
    _heartbeat.dispose();
    _levelsugar.dispose();
    _lastBPDate.dispose();
    _lastSelfManagementDate.dispose();
    _confidenceLevel.dispose();
    _lastConfidenceDate.dispose();
    _hba1cValue.dispose();
    _hba1cDate.dispose();
    _ldlValue.dispose();
    _ldlDate.dispose();
    _footExamDate.dispose();
    _retinopathyDate.dispose();
    _sakDate.dispose();
    _smokingStatusAssessmentDate.dispose();
    _smokingCessationCounselingDate.dispose();
    _cholesterolValue.dispose();
    _cholesterolDate.dispose();
    _riskLevel.dispose();
    _efValue.dispose();
    _echoDate.dispose();
    _hospitalizationDate.dispose();
    _fluVaccinationDate.dispose();
    _egfrValue.dispose();
    
    super.dispose();
  }

  void calculateBMI() {
  final heightText = _heightController.text;
  final weightText = _weightController.text;
  
  if (heightText.isNotEmpty && weightText.isNotEmpty) {
    final height = double.tryParse(heightText);
    final weight = double.tryParse(weightText);
    
    if (height != null && weight != null && height > 0) {
      // ИМТ = вес (кг) / (рост (м))²
      final heightInMeters = height / 100; // переводим см в метры
      bmi = weight / (heightInMeters * heightInMeters);
      setState(() {}); // обновляем UI
    }
  }
}

Color _getBMIColor(double bmi) {
  if (bmi < 18.5) return Colors.blue;      // Недостаточный вес
  if (bmi < 25) return Colors.green;       // Нормальный вес
  if (bmi < 30) return Colors.orange;       // Избыточный вес
  return Colors.red;                       // Ожирение
  }

  Widget _buildHypertensionSection() {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Color(0xFFEEF6FC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Артериальная гипертензия', style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w600, color: ColorStyles.blackColor)),
          const SizedBox(height: 16),
          
          // ЛПНП поля
          Text('Показания последнего анализа ЛПНП (Липопротеины Низкой Плотности)(ммоль/л)', style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w600, color: ColorStyles.blackColor)),
          const SizedBox(height: 4),
          AddTextField(controller: _ldlValue, hintText: 'Например, 3'),
          const SizedBox(height: 8),
          Text('Дата последнего анализа ЛПНП (Липопротеины Низкой Плотности)', style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w600, color: ColorStyles.blackColor)),
          const SizedBox(height: 4),
          AddTextField(
            controller: _ldlDate,
            hintText: 'дд.мм.гггг',
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                _ldlDate.text = '${picked.day}.${picked.month}.${picked.year}';
              }
            },
          ),
          const SizedBox(height: 8),
          
          // Холестерин поля
          Text('Показания последнего анализа холестерина (ммоль/л)', style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w600, color: ColorStyles.blackColor)),
          const SizedBox(height: 4),
          AddTextField(controller: _cholesterolValue, hintText: 'Например, 5.5'),
          const SizedBox(height: 8),
          Text('Дата последнего анализа холестерина', style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w600, color: ColorStyles.blackColor)),
          const SizedBox(height: 4),
          AddTextField(
            controller: _cholesterolDate,
            hintText: 'дд.мм.гггг',
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                _cholesterolDate.text = '${picked.day}.${picked.month}.${picked.year}';
              }
            },
          ),
          const SizedBox(height: 16),
          
          // Степень риска
          Text('Степень риска (АГ)', style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w600, color: ColorStyles.blackColor)),
          const SizedBox(height: 8),
          Row(
            children: [
              Radio<String>(
                value: 'Нормальное АД',
                groupValue: hypertensionRiskLevel,
                onChanged: (String? value) {
                  setState(() {
                    hypertensionRiskLevel = value;
                  });
                },
              ),
              Text('Нормальное АД'),
            ],
          ),
          Row(
            children: [
              Radio<String>(
                value: 'Степень 1',
                groupValue: hypertensionRiskLevel,
                onChanged: (String? value) {
                  setState(() {
                    hypertensionRiskLevel = value;
                  });
                },
              ),
              Text('Степень 1'),
            ],
          ),
          Row(
            children: [
              Radio<String>(
                value: 'Степень 2',
                groupValue: hypertensionRiskLevel,
                onChanged: (String? value) {
                  setState(() {
                    hypertensionRiskLevel = value;
                  });
                },
              ),
              Text('Степень 2'),
            ],
          ),
          Row(
            children: [
              Radio<String>(
                value: 'Степень 3',
                groupValue: hypertensionRiskLevel,
                onChanged: (String? value) {
                  setState(() {
                    hypertensionRiskLevel = value;
                  });
                },
              ),
              Text('Степень 3'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeartFailureSection() {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Color(0xFFEEF6FC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Хроническая сердечная недостаточность', style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w600, color: ColorStyles.blackColor)),
          const SizedBox(height: 16),
          
          // NYHA Classification
          Text('NYHA Classification (NYHA)', style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w600, color: ColorStyles.blackColor)),
          const SizedBox(height: 8),
          Row(
            children: [
              Radio<String>(
                value: 'Класс I',
                groupValue: nyhaClass,
                onChanged: (String? value) {
                  setState(() {
                    nyhaClass = value;
                  });
                },
              ),
              Text('Класс I'),
              Radio<String>(
                value: 'Класс II',
                groupValue: nyhaClass,
                onChanged: (String? value) {
                  setState(() {
                    nyhaClass = value;
                  });
                },
              ),
              Text('Класс II'),
            ],
          ),
          Row(
            children: [
              Radio<String>(
                value: 'Класс III',
                groupValue: nyhaClass,
                onChanged: (String? value) {
                  setState(() {
                    nyhaClass = value;
                  });
                },
              ),
              Text('Класс III'),
              Radio<String>(
                value: 'Класс IV',
                groupValue: nyhaClass,
                onChanged: (String? value) {
                  setState(() {
                    nyhaClass = value;
                  });
                },
              ),
              Text('Класс IV'),
            ],
          ),
          const SizedBox(height: 16),
          
          // EF Value
          Text('Последний показатель ФВ по эхокардиографии', style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w600, color: ColorStyles.blackColor)),
          const SizedBox(height: 4),
          AddTextField(controller: _efValue, hintText: 'Введите показатель в %'),
          const SizedBox(height: 8),
          
          // Echo Date
          Text('Дата последней эхокардиографии', style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w600, color: ColorStyles.blackColor)),
          const SizedBox(height: 4),
          AddTextField(
            controller: _echoDate,
            hintText: 'дд.мм.гггг',
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                _echoDate.text = '${picked.day}.${picked.month}.${picked.year}';
              }
            },
          ),
          const SizedBox(height: 16),
          
          // Beta blockers
          Text('Принимает ли пациент бета-блокаторы?', style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w600, color: ColorStyles.blackColor)),
          const SizedBox(height: 4),
          Row(
            children: [
              Radio<bool>(
                value: true,
                groupValue: takesBetaBlockers,
                onChanged: (bool? value) {
                  setState(() {
                    takesBetaBlockers = value;
                  });
                },
              ),
              Text('Да'),
              Radio<bool>(
                value: false,
                groupValue: takesBetaBlockers,
                onChanged: (bool? value) {
                  setState(() {
                    takesBetaBlockers = value;
                  });
                },
              ),
              Text('Нет'),
            ],
          ),
          const SizedBox(height: 8),
          
          // ACE Inhibitor
          Text('Принимает ли пациент ингибитор АПФ или БРА?', style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w600, color: ColorStyles.blackColor)),
          const SizedBox(height: 4),
          Row(
            children: [
              Radio<bool>(
                value: true,
                groupValue: takesACEInhibitor,
                onChanged: (bool? value) {
                  setState(() {
                    takesACEInhibitor = value;
                  });
                },
              ),
              Text('Да'),
              Radio<bool>(
                value: false,
                groupValue: takesACEInhibitor,
                onChanged: (bool? value) {
                  setState(() {
                    takesACEInhibitor = value;
                  });
                },
              ),
              Text('Нет'),
            ],
          ),
          const SizedBox(height: 8),
          
          // Aldosterone antagonists
          Text('Принимает ли пациент антагонисты альдостерона? (например, спиронолактон)', style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w600, color: ColorStyles.blackColor)),
          const SizedBox(height: 4),
          Row(
            children: [
              Radio<bool>(
                value: true,
                groupValue: takesAldosteroneAntagonists,
                onChanged: (bool? value) {
                  setState(() {
                    takesAldosteroneAntagonists = value;
                  });
                },
              ),
              Text('Да'),
              Radio<bool>(
                value: false,
                groupValue: takesAldosteroneAntagonists,
                onChanged: (bool? value) {
                  setState(() {
                    takesAldosteroneAntagonists = value;
                  });
                },
              ),
              Text('Нет'),
            ],
          ),
          const SizedBox(height: 16),
          
          // Hospitalization Date
          Text('Дата последней госпитализации', style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w600, color: ColorStyles.blackColor)),
          const SizedBox(height: 4),
          AddTextField(
            controller: _hospitalizationDate,
            hintText: 'дд.мм.гггг',
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                _hospitalizationDate.text = '${picked.day}.${picked.month}.${picked.year}';
              }
            },
          ),
          const SizedBox(height: 8),
          
          // Flu Vaccination Date
          Text('Дата последней вакцинации против гриппа', style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w600, color: ColorStyles.blackColor)),
          const SizedBox(height: 4),
          AddTextField(
            controller: _fluVaccinationDate,
            hintText: 'дд.мм.гггг',
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                _fluVaccinationDate.text = '${picked.day}.${picked.month}.${picked.year}';
              }
            },
          ),
          const SizedBox(height: 8),
          
          // eGFR Value
          Text('Показания последнего рСКФ', style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w600, color: ColorStyles.blackColor)),
          const SizedBox(height: 4),
          AddTextField(controller: _egfrValue, hintText: 'Введите класс'),
          const SizedBox(height: 16),
          
          // EchoECG Study
          Text('Проводилось ли пациенту с сердечной недостаточностью исследование ЭхоЭКГ во время диагностирования?', style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w600, color: ColorStyles.blackColor)),
          const SizedBox(height: 4),
          Row(
            children: [
              Radio<bool>(
                value: true,
                groupValue: hasEchoECGStudy,
                onChanged: (bool? value) {
                  setState(() {
                    hasEchoECGStudy = value;
                  });
                },
              ),
              Text('Да'),
              Radio<bool>(
                value: false,
                groupValue: hasEchoECGStudy,
                onChanged: (bool? value) {
                  setState(() {
                    hasEchoECGStudy = value;
                  });
                },
              ),
              Text('Нет'),
            ],
          ),
          const SizedBox(height: 8),
          
          // Left Ventricular Dysfunction
          Text('Имеется ли у пациента дисфункция левого желудочка с систолической дисфункцией и выбросом фракции < 40%?', style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w600, color: ColorStyles.blackColor)),
          const SizedBox(height: 4),
          Row(
            children: [
              Radio<bool>(
                value: true,
                groupValue: hasLeftVentricularDysfunction,
                onChanged: (bool? value) {
                  setState(() {
                    hasLeftVentricularDysfunction = value;
                  });
                },
              ),
              Text('Да'),
              Radio<bool>(
                value: false,
                groupValue: hasLeftVentricularDysfunction,
                onChanged: (bool? value) {
                  setState(() {
                    hasLeftVentricularDysfunction = value;
                  });
                },
              ),
              Text('Нет'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDiabetesSection() {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Color(0xFFEEF6FC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Сахарный диабет', style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w600, color: ColorStyles.blackColor)),
          const SizedBox(height: 16),
          
          // HbA1c Analysis
          Text('Показания последнего анализа HbA1c (гликированный гемоглобин) (%)', style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w600, color: ColorStyles.blackColor)),
          const SizedBox(height: 4),
          AddTextField(controller: _hba1cValue, hintText: 'Например, 7.2'),
          const SizedBox(height: 8),
          Text('Дата последнего анализа HbA1c (гликированный гемоглобин)', style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w600, color: ColorStyles.blackColor)),
          const SizedBox(height: 4),
          AddTextField(
            controller: _hba1cDate,
            hintText: 'дд.мм.гггг',
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                _hba1cDate.text = '${picked.day}.${picked.month}.${picked.year}';
              }
            },
          ),
          const SizedBox(height: 8),
          
          // LDL Analysis
          Text('Показания последнего анализа ЛПНП (Липопротеины Низкой Плотности)(ммоль/л)', style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w600, color: ColorStyles.blackColor)),
          const SizedBox(height: 4),
          AddTextField(controller: _ldlValue, hintText: 'например, 3'),
          const SizedBox(height: 8),
          Text('Дата последнего анализа ЛПНП (Липопротеины Низкой Плотности)', style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w600, color: ColorStyles.blackColor)),
          const SizedBox(height: 4),
          AddTextField(
            controller: _ldlDate,
            hintText: 'дд.мм.гггг',
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                _ldlDate.text = '${picked.day}.${picked.month}.${picked.year}';
              }
            },
          ),
          const SizedBox(height: 16),
          
          // CVD Question
          Text('Имеется ли у пациента ССЗ (стенокардия, ОИМ, инсульт)?', style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w600, color: ColorStyles.blackColor)),
          const SizedBox(height: 4),
          Row(
            children: [
              Radio<bool>(
                value: true,
                groupValue: hasCVD,
                onChanged: (bool? value) {
                  setState(() {
                    hasCVD = value;
                  });
                },
              ),
              Text('Да'),
              Radio<bool>(
                value: false,
                groupValue: hasCVD,
                onChanged: (bool? value) {
                  setState(() {
                    hasCVD = value;
                  });
                },
              ),
              Text('Нет'),
            ],
          ),
          const SizedBox(height: 8),
          
          // Foot Examination Date
          Text('Дата последнего осмотра стопы', style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w600, color: ColorStyles.blackColor)),
          const SizedBox(height: 4),
          AddTextField(
            controller: _footExamDate,
            hintText: 'дд.мм.гггг',
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                _footExamDate.text = '${picked.day}.${picked.month}.${picked.year}';
              }
            },
          ),
          const SizedBox(height: 8),
          
          // Diabetic Retinopathy
          Text('Есть ли у пациента диабетическая ретинопатия?', style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w600, color: ColorStyles.blackColor)),
          const SizedBox(height: 4),
          Row(
            children: [
              Radio<bool>(
                value: true,
                groupValue: hasRetinopathy,
                onChanged: (bool? value) {
                  setState(() {
                    hasRetinopathy = value;
                  });
                },
              ),
              Text('Да'),
              Radio<bool>(
                value: false,
                groupValue: hasRetinopathy,
                onChanged: (bool? value) {
                  setState(() {
                    hasRetinopathy = value;
                  });
                },
              ),
              Text('Нет'),
            ],
          ),
          const SizedBox(height: 8),
          
          // Fundus Examination Date
          Text('Дата последнего обследования глазного дна на ретинопатию', style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w600, color: ColorStyles.blackColor)),
          const SizedBox(height: 4),
          AddTextField(
            controller: _retinopathyDate,
            hintText: 'дд.мм.гггг',
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                _retinopathyDate.text = '${picked.day}.${picked.month}.${picked.year}';
              }
            },
          ),
          const SizedBox(height: 8),
          
          // Statin Intake
          Text('Принимает ли пациент статин?', style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w600, color: ColorStyles.blackColor)),
          const SizedBox(height: 4),
          Row(
            children: [
              Radio<bool>(
                value: true,
                groupValue: takesStatin,
                onChanged: (bool? value) {
                  setState(() {
                    takesStatin = value;
                  });
                },
              ),
              Text('Да'),
              Radio<bool>(
                value: false,
                groupValue: takesStatin,
                onChanged: (bool? value) {
                  setState(() {
                    takesStatin = value;
                  });
                },
              ),
              Text('Нет'),
            ],
          ),
          const SizedBox(height: 8),
          
          // SAK Analysis Date
          Text('Дата последнего анализа САК', style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w600, color: ColorStyles.blackColor)),
          const SizedBox(height: 4),
          AddTextField(
            controller: _sakDate,
            hintText: 'дд.мм.гггг',
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                _sakDate.text = '${picked.day}.${picked.month}.${picked.year}';
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddPatientBloc, AddPatientState>(
      listener: (context, state) {
        if (state is AddPatientSuccess) {
          SnackbarService.showSuccess(context, 'Пациент успешно добавлен!');
          Navigator.pop(context);
        }
        if (state is AddPatientFailure) {
          SnackbarService.showError(context, 'Ошибка: ${state.error}');
        }
        if (state is SectorsLoaded) {
          setState(() {
            sectors = state.sectors;
          });
          print('Загружено участков: ${sectors.length}');
          for (var sector in sectors) {
            print('Участок: ${sector.address} (ID: ${sector.sectorId})');
          }
        }
        if (state is SectorsLoadFailed) {
          print('Ошибка загрузки участков: ${state.error}');
          SnackbarService.showError(context, 'Ошибка загрузки участков: ${state.error}');
        }
      },
      child: BlocBuilder<AddPatientBloc, AddPatientState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Color(0xFF1C6BA4),
              title: Text('Добавить пациента',style: GoogleFonts.montserrat(fontSize: 17,
              color: ColorStyles.whiteColor,fontWeight: FontWeight.w500,
                ),
              ),
            ),
            body: state is AddPatientLoading 
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Секция 1: Личные данные
              Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Color(0xFFEEF6FC),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
              Row(
                children: [
                        Text('Участок',style: GoogleFonts.montserrat(fontSize: 12,fontWeight: FontWeight.w600,color: ColorStyles.blackColor))
                ],
              ),
              const SizedBox(height: 4),
                    DropdownButtonFormField<SectorModel>(
                      value: selectedSector,
                      hint: Text('Выберите участок'),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: sectors.map((SectorModel sector) {
                        return DropdownMenuItem<SectorModel>(
                          value: sector,
                          child: Text(sector.address),
                        );
                      }).toList(),
                      onChanged: (SectorModel? newValue) {
                        setState(() {
                          selectedSector = newValue;
                        });
                      },
                    ),
              const SizedBox(height: 8),
                    
              Row(
                children: [
                  Text('Фамилия',style: GoogleFonts.montserrat(fontSize: 12,fontWeight: FontWeight.w600,color: ColorStyles.blackColor),)
                ],
              ),
              const SizedBox(height: 4),
                    AddTextField(controller: _surnameController,hintText: 'Фамилия',),
              const SizedBox(height: 8),
                    
              Row(
                children: [
                  Text('Имя',style: GoogleFonts.montserrat(fontSize: 12,fontWeight: FontWeight.w600,color: ColorStyles.blackColor),)
                ],
              ),
              const SizedBox(height: 4),
                    AddTextField(controller: _nameController,hintText: 'Имя',),
              const SizedBox(height: 8),
                    
              Row(
                children: [
                  Text('Отчество',style: GoogleFonts.montserrat(fontSize: 12,fontWeight: FontWeight.w600,color: ColorStyles.blackColor),)
                ],
              ),
              const SizedBox(height: 4),
                    AddTextField(controller: _middleNameController,hintText: 'Отчество',),
              const SizedBox(height: 8),
                    
              Row(
                children: [
                  Text('ИИН',style: GoogleFonts.montserrat(fontSize: 12,fontWeight: FontWeight.w600,color: ColorStyles.blackColor),)
                ],
              ),
              const SizedBox(height: 4),
                    AddTextField(controller: _iinController,hintText: 'Введите ИИН',),
              const SizedBox(height: 8),
                    
              Row(
                children: [
                  Text('Дата рождения',style: GoogleFonts.montserrat(fontSize: 12,fontWeight: FontWeight.w600,color: ColorStyles.blackColor),)
                ],
              ),
              const SizedBox(height: 4),
              AddTextField(
                      controller: _birthController,
                      hintText: 'ДД.ММ.ГГГГ',
  onTap: () async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
                          _birthController.text =
          '${picked.day}.${picked.month}.${picked.year}';
    }
  },
                    ),

                     Row(
                      children: [
                        Text('Пол',style: GoogleFonts.montserrat(fontSize: 12,fontWeight: FontWeight.w600,color: ColorStyles.blackColor),)
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Radio<String>(
                          value: 'Мужской',
                          groupValue: selectedGender,
                          onChanged: (String? value) {
                            setState(() {
                              selectedGender = value;
                            });
                          },
                        ),
                        const Text('Мужской'),
                        const SizedBox(width: 20),
                        Radio<String>(
                          value: 'Женский', 
                          groupValue: selectedGender,
                          onChanged: (String? value) {
                            setState(() {
                              selectedGender = value;
                            });
                          },
                        ),
                        const Text('Женский'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    Row(
                      children: [
                        Text('Адрес проживания',style: GoogleFonts.montserrat(fontSize: 12,fontWeight: FontWeight.w600,color: ColorStyles.blackColor),)
                      ],
                    ),
                    const SizedBox(height: 4),
                    AddTextField(controller: _addressController,hintText: 'Введите адрес',),
                    const SizedBox(height: 8),
                    
                    Row(
                      children: [
                        Text('Почта',style: GoogleFonts.montserrat(fontSize: 12,fontWeight: FontWeight.w600,color: ColorStyles.blackColor),)
                      ],
                    ),
                    const SizedBox(height: 4),
                    AddTextField(controller: _mailController,hintText: 'Почта',),
                    const SizedBox(height: 8),
                    
                    Row(
                      children: [
                        Text('Контактный телефон',style: GoogleFonts.montserrat(fontSize: 12,fontWeight: FontWeight.w600,color: ColorStyles.blackColor),)
                      ],
                    ),
                    const SizedBox(height: 4),
                    AddTextField(controller: _contactController,hintText: '+7 (__)-___-___',),
                  ],
                ),
              ),
              
              // Секция 2: Физические показатели
              Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Color(0xFFEEF6FC),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Рост (см)', style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w600, color: ColorStyles.blackColor)),
                        const SizedBox(height: 4),
                        AddTextField(controller: _heightController, hintText: 'Введите рост',onChanged: (value) => calculateBMI(),),
                        const SizedBox(height: 8),
                        Text('Вес (кг)', style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w600, color: ColorStyles.blackColor)),
                        const SizedBox(height: 4),
                        AddTextField(controller: _weightController, hintText: 'Введите вес',onChanged: (value) => calculateBMI(),),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 120,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        
                        const SizedBox(height: 8),
                        Text(
  bmi != null ? bmi!.toStringAsFixed(1) : '0', // ← Замените '21.2'
  style: GoogleFonts.montserrat(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: bmi != null ? _getBMIColor(bmi!) : Colors.grey,
  ),
),
                      ],
                    ),
                  ),
                ],
              ),
                  ],
                ),
              ),
              
              
              // Секция 4: Выбор заболевания
              Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Color(0xFFEEF6FC),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Выберите заболевание:', style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w600, color: ColorStyles.blackColor)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Radio<String>(
                          value: 'Артериальная гипертензия',
                          groupValue: selectedDisease,
                          onChanged: (String? value) {
                            setState(() {
                              selectedDisease = value;
                            });
                          },
                        ),
                        Text(
                          'Артериальная гипертензия',
                          style: GoogleFonts.montserrat(color: ColorStyles.blackColor),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Radio<String>(
                          value: 'Хроническая сердечная недостаточность',
                          groupValue: selectedDisease,
                          onChanged: (String? value) {
                            setState(() {
                              selectedDisease = value;
                            });
                          },
                        ),
                        Expanded(
                          child: Text(
                            'Хроническая сердечная недостаточность',
                            style: GoogleFonts.montserrat(color: ColorStyles.blackColor),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Radio<String>(
                          value: 'Сахарный диабет',
                          groupValue: selectedDisease,
                          onChanged: (String? value) {
                            setState(() {
                              selectedDisease = value;
                            });
                          },
                        ),
                        Text(
                          'Сахарный диабет',
                          style: GoogleFonts.montserrat(color: ColorStyles.blackColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Условные секции в зависимости от выбранного заболевания
              if (selectedDisease == 'Артериальная гипертензия') ...[
                _buildHypertensionSection(),
              ] else if (selectedDisease == 'Хроническая сердечная недостаточность') ...[
                _buildHeartFailureSection(),
              ] else if (selectedDisease == 'Сахарный диабет') ...[
                _buildDiabetesSection(),
              ],
              const SizedBox(height: 8),
              
              // Секция 5: Медицинские показатели
              Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Color(0xFFEEF6FC),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('Артериальное давление',style: GoogleFonts.montserrat(fontSize: 12,fontWeight: FontWeight.w600,color: ColorStyles.blackColor),),
                        Text('*', style: TextStyle(color: Colors.red, fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    AddTextField(controller: _arterialdavlenie,hintText: 'Пример: 120/80',),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text('Частота сердцебиения',style: GoogleFonts.montserrat(fontSize: 12,fontWeight: FontWeight.w600,color: ColorStyles.blackColor),)
                      ],
                    ),
                    const SizedBox(height: 4),
                    AddTextField(controller: _heartbeat,hintText: 'Введите частоту сердцебиения',),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text('Уровень сахара',style: GoogleFonts.montserrat(fontSize: 12,fontWeight: FontWeight.w600,color: ColorStyles.blackColor),),
                        Text('*', style: TextStyle(color: Colors.red, fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    AddTextField(controller: _levelsugar,hintText: 'Введите уровень сахара',),
                  ],
                ),
              ),
              
              // Секция 6: Дополнительные медицинские показатели
              Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Color(0xFFEEF6FC),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('Дата последнего измерения АД',style: GoogleFonts.montserrat(fontSize: 12,fontWeight: FontWeight.w600,color: ColorStyles.blackColor),)
                      ],
                    ),
                    const SizedBox(height: 4),
                    AddTextField(
                      controller: _lastBPDate,
                      hintText: 'ДД.ММ.ГГГГ',
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          _lastBPDate.text = '${picked.day}.${picked.month}.${picked.year}';
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text('Дата последней цели по самоменеджменту',style: GoogleFonts.montserrat(fontSize: 12,fontWeight: FontWeight.w600,color: ColorStyles.blackColor),)
                      ],
                    ),
                    const SizedBox(height: 4),
                    AddTextField(
                      controller: _lastSelfManagementDate,
                      hintText: 'ДД.ММ.ГГГГ',
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          _lastSelfManagementDate.text = '${picked.day}.${picked.month}.${picked.year}';
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text('Статус курения?',style: GoogleFonts.montserrat(fontSize: 12,fontWeight: FontWeight.w600,color: ColorStyles.blackColor),)
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Radio<String>(
                          value: 'Да',
                          groupValue: smokingStatus,
                          onChanged: (String? value) {
                            setState(() {
                              smokingStatus = value;
                            });
                          },
                        ),
                        Text('Да'),
                        Radio<String>(
                          value: 'Нет',
                          groupValue: smokingStatus,
                          onChanged: (String? value) {
                            setState(() {
                              smokingStatus = value;
                            });
                          },
                        ),
                        Text('Нет'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    // Показываем поля дат только если статус курения "Да"
                    if (smokingStatus == 'Да') ...[
                      Row(
                        children: [
                          Expanded(
                            child: Text('Дата последней оценки статуса курения',style: GoogleFonts.montserrat(fontSize: 12,fontWeight: FontWeight.w600,color: ColorStyles.blackColor),)
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      AddTextField(
                        controller: _smokingStatusAssessmentDate,
                        hintText: 'дд.мм.гггг',
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            _smokingStatusAssessmentDate.text = '${picked.day}.${picked.month}.${picked.year}';
                          }
                        },
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Text('Дата последнего консультирования по отказу от курения',style: GoogleFonts.montserrat(fontSize: 12,fontWeight: FontWeight.w600,color: ColorStyles.blackColor),)
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      AddTextField(
                        controller: _smokingCessationCounselingDate,
                        hintText: 'дд.мм.гггг',
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            _smokingCessationCounselingDate.text = '${picked.day}.${picked.month}.${picked.year}';
                          }
                        },
                      ),
                      const SizedBox(height: 8),
                    ],
                    
                    Row(
                      children: [
                        Text('Уровень уверенности',style: GoogleFonts.montserrat(fontSize: 12,fontWeight: FontWeight.w600,color: ColorStyles.blackColor),)
                      ],
                    ),
                    const SizedBox(height: 4),
                    AddTextField(controller: _confidenceLevel,hintText: '0-10',),
                    const SizedBox(height: 8),
  
                        Text('Дата последнего измерения уровня уверенности',style: GoogleFonts.montserrat(fontSize: 12,fontWeight: FontWeight.w600,color: ColorStyles.blackColor),),
                
                    const SizedBox(height: 4),
                    AddTextField(
                      controller: _lastConfidenceDate,
                      hintText: 'ДД.ММ.ГГГГ',
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          _lastConfidenceDate.text = '${picked.day}.${picked.month}.${picked.year}';
                        }
                      },
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height:10),
     SizedBox(
  width: 200, 
  height: 35, 
  child: TextButton(
    style: TextButton.styleFrom(
      backgroundColor: Color(0xFF1C6BA4),
      foregroundColor: Colors.white, 
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    ),
    onPressed: () {
      final patient = PatientModel(
        sectorId: selectedSector?.sectorId,
        lastName: _surnameController.text,
        firstName: _nameController.text,
        middleName: _middleNameController.text.isEmpty ? null : _middleNameController.text,
        iin: _iinController.text,
        birthDate: _convertDateFormat(_birthController.text),
        heightCm: _heightController.text.isEmpty ? null : int.tryParse(_heightController.text),
        weightKg: _weightController.text.isEmpty ? null : int.tryParse(_weightController.text),
        gender: selectedGender == 'Мужской' ? 'male' : 'female',
        address: _addressController.text,
        phoneNumber: _contactController.text,
        diseases: selectedDisease != null ? [selectedDisease == 'Артериальная гипертензия' ? 1 : selectedDisease == 'Хроническая сердечная недостаточность' ? 2 : 3] : [],
        bloodPressure: _arterialdavlenie.text.isEmpty ? null : _arterialdavlenie.text,
        sugarLevel: _levelsugar.text.isEmpty ? null : double.tryParse(_levelsugar.text),
        heartRate: _heartbeat.text.isEmpty ? null : int.tryParse(_heartbeat.text),
        visitData: VisitData(
          visitHypertension: VisitHypertension(
            ldl: _ldlValue.text.isEmpty ? null : double.tryParse(_ldlValue.text),
            ldlDate: _ldlDate.text.isEmpty ? null : _convertToISODate(_ldlDate.text),
            cholesterol: _cholesterolValue.text.isEmpty ? null : double.tryParse(_cholesterolValue.text),
            cholesterolDate: _cholesterolDate.text.isEmpty ? null : _convertToISODate(_cholesterolDate.text),
            riskLevel: _riskLevel.text.isEmpty ? null : int.tryParse(_riskLevel.text),
            visitGeneral: VisitGeneral(
              bmi: bmi,
              bpMeasurementDate: _lastBPDate.text.isEmpty ? null : _convertToISODate(_lastBPDate.text),
              diastolicBp: _arterialdavlenie.text.isEmpty ? null : int.tryParse(_arterialdavlenie.text.split('/')[1]),
              heightCm: _heightController.text.isEmpty ? null : int.tryParse(_heightController.text),
              selfConfidenceAssessmentDate: _lastConfidenceDate.text.isEmpty ? null : _convertToISODate(_lastConfidenceDate.text),
              selfConfidenceLevel: _confidenceLevel.text.isEmpty ? null : int.tryParse(_confidenceLevel.text),
              selfManagementGoalDate: _lastSelfManagementDate.text.isEmpty ? null : _convertToISODate(_lastSelfManagementDate.text),
              smokingCessationCounselingDate: _smokingCessationCounselingDate.text.isEmpty ? null : _convertToISODate(_smokingCessationCounselingDate.text),
              smokingStatus: smokingStatus == 'Да',
              smokingStatusAssessmentDate: _smokingStatusAssessmentDate.text.isEmpty ? null : _convertToISODate(_smokingStatusAssessmentDate.text),
              systolicBp: _arterialdavlenie.text.isEmpty ? null : int.tryParse(_arterialdavlenie.text.split('/')[0]),
              weightKg: _weightController.text.isEmpty ? null : int.tryParse(_weightController.text),
            ),
          ),
        ),
      );
      
      context.read<AddPatientBloc>().add(AddPatientButtonPressed(patient));
    },
    child: const Text('Сохранить'),
  ),
)

            ],
          ),
        ),
      ),
          );
        },
      ),
    );
  }
}