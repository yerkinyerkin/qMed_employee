import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qmed_employee/core/const/color_styles.dart';
import 'package:qmed_employee/core/common/snackbar_service.dart';
import 'package:qmed_employee/features/add_patient/widgets/add_text_field.dart';
import 'package:qmed_employee/features/add_patient/logic/bloc/add_patient_bloc.dart';
import 'package:qmed_employee/features/add_patient/logic/bloc/add_patient_event.dart' as AddPatientEvents;
import 'package:qmed_employee/features/add_patient/logic/bloc/add_patient_state.dart' as AddPatientStates;
import 'package:qmed_employee/features/add_patient/logic/data/models/add_patient_model.dart';
import 'package:qmed_employee/features/add_patient/logic/data/models/sector_model.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:dio/dio.dart';
import 'package:qmed_employee/core/dio_interceptor/dio_interceptor.dart';
import 'package:qmed_employee/features/about_patient/logic/bloc/about_patient_bloc.dart';
import 'package:qmed_employee/features/about_patient/logic/bloc/about_patient_event.dart' as AboutPatientEvents;
import 'package:qmed_employee/features/about_patient/logic/bloc/about_patient_state.dart' as AboutPatientStates;
import 'package:qmed_employee/core/get_it/injection_container.dart';
class EditPatientScreen extends StatefulWidget {
  final int patientId;
  
  const EditPatientScreen({super.key, required this.patientId});

  @override
  State<EditPatientScreen> createState() => _EditPatientScreenState();
}

class _EditPatientScreenState extends State<EditPatientScreen> {
  String? selectedNoezologya;
  String? smokingStatus;
  SectorModel? selectedSector;
  List<SectorModel> sectors = [];
  double? bmi;
  bool isLoading = true;
  final _uchastokController = TextEditingController();
  final _surnameController = TextEditingController();
  final _nameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _iinController = TextEditingController();
  final _birthController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _noezologyaController = TextEditingController();
  final _addressController = TextEditingController();
  final _contactController = TextEditingController();
  final _emailController = TextEditingController();
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

  // Маска для номера телефона
  final phoneMaskFormatter = MaskTextInputFormatter(
    mask: '+7 (###) ###-##-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  String? selectedDisease;
  String? selectedGender;
  
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
  Dio get dio => DioInterceptor(Dio()).getDio;
  int? _loadedSectorId;
  int? _loadedMedStaffId;
  
  @override
  void initState() {
    super.initState();
    context.read<AddPatientBloc>().add(AddPatientEvents.LoadSectors());
    _loadPatientData();
  }

  Future<void> _loadPatientData() async {
    try {
      final response = await dio.get('/patient/${widget.patientId}');
      final data = response.data;
      
      setState(() {
        // Заполняем основные поля
        _surnameController.text = data['last_name'] ?? '';
        _nameController.text = data['first_name'] ?? '';
        _middleNameController.text = data['middle_name'] ?? '';
        _iinController.text = data['iin'] ?? '';
        
        // Дата рождения
        if (data['birth_date'] != null) {
          final date = DateTime.parse(data['birth_date']);
          _birthController.text = '${date.day}.${date.month}.${date.year}';
        }
        
        // Рост и вес
        if (data['height_cm'] != null) {
          _heightController.text = data['height_cm'].toString();
        }
        if (data['weight_kg'] != null) {
          _weightController.text = data['weight_kg'].toString();
        }
        
        // Адрес
        _addressController.text = data['address'] ?? '';
        
        // Телефон
        _contactController.text = data['phone_number'] ?? '';
        
        // Email
        _emailController.text = data['mail'] ?? '';
        
        // Gender
        selectedGender = data['gender'];
        
        // Артериальное давление, сахар, пульс
        _arterialdavlenie.text = data['blood_pressure'] ?? '';
        if (data['sugar_level'] != null) {
          _levelsugar.text = data['sugar_level'].toString();
        }
        if (data['heart_rate'] != null) {
          _heartbeat.text = data['heart_rate'].toString();
        }
        
        // Участок
        if (data['sector_id'] != null) {
          _loadedSectorId = data['sector_id'];
        } else if (data['sector'] != null && data['sector']['sector_id'] != null) {
          _loadedSectorId = data['sector']['sector_id'];
        } else if (data['sector'] != null && data['sector']['SectorID'] != null) {
          _loadedSectorId = data['sector']['SectorID'];
        }
        
        // Med Staff ID
        if (data['med_staff_id'] != null) {
          _loadedMedStaffId = data['med_staff_id'];
        }
        
        // Заболевания
        if (data['diseases'] != null && data['diseases'].isNotEmpty) {
          // API может возвращать diseases как массив чисел или объектов
          dynamic diseaseData = data['diseases'][0];
          int? diseaseId;
          
          if (diseaseData is int) {
            diseaseId = diseaseData;
          } else if (diseaseData is Map && diseaseData['disease_id'] != null) {
            diseaseId = diseaseData['disease_id'];
          }
          
          if (diseaseId == 1) {
            selectedDisease = 'Артериальная гипертензия';
          } else if (diseaseId == 2) {
            selectedDisease = 'Хроническая сердечная недостаточность';
          } else if (diseaseId == 3) {
            selectedDisease = 'Сахарный диабет';
          }
        }
        
        isLoading = false;
      });
      
      // Вычисляем ИМТ
      calculateBMI();
      
    } catch (e) {
      print('Ошибка загрузки пациента: $e');
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        SnackbarService.showError(context, 'Ошибка загрузки данных пациента');
      }
    }
  }
  
  void _loadSectorForEdit() {
    if (_loadedSectorId != null && sectors.isNotEmpty) {
      final loadedSectors = sectors.where((s) => s.sectorId == _loadedSectorId).toList();
      
      if (loadedSectors.isNotEmpty) {
        setState(() {
          selectedSector = loadedSectors.first;
        });
      }
    }
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
    _emailController.dispose();
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

  void _clearForm() {
    setState(() {
      // Очищаем все контроллеры
      _surnameController.clear();
      _nameController.clear();
      _middleNameController.clear();
      _iinController.clear();
      _birthController.clear();
      _heightController.clear();
      _weightController.clear();
      _addressController.clear();
      _contactController.clear();
      phoneMaskFormatter.clear();
      _arterialdavlenie.clear();
      _heartbeat.clear();
      _levelsugar.clear();
      _lastBPDate.clear();
      _lastSelfManagementDate.clear();
      _confidenceLevel.clear();
      _lastConfidenceDate.clear();
      _hba1cValue.clear();
      _hba1cDate.clear();
      _ldlValue.clear();
      _ldlDate.clear();
      _footExamDate.clear();
      _retinopathyDate.clear();
      _sakDate.clear();
      _smokingStatusAssessmentDate.clear();
      _smokingCessationCounselingDate.clear();
      _cholesterolValue.clear();
      _cholesterolDate.clear();
      _riskLevel.clear();
      _efValue.clear();
      _echoDate.clear();
      _hospitalizationDate.clear();
      _fluVaccinationDate.clear();
      _egfrValue.clear();
      
      selectedDisease = null;
      selectedSector = null;
      smokingStatus = null;
      hypertensionRiskLevel = null;
      nyhaClass = null;
      takesBetaBlockers = null;
      takesACEInhibitor = null;
      takesAldosteroneAntagonists = null;
      hasEchoECGStudy = null;
      hasLeftVentricularDysfunction = null;
      hasCVD = null;
      hasRetinopathy = null;
      takesStatin = null;
      bmi = null;
    });
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<AboutPatientBloc>()),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AddPatientBloc, AddPatientStates.AddPatientState>(
      listener: (context, state) {
        if (state is AddPatientStates.AddPatientSuccess) {
          SnackbarService.showSuccess(context, 'Пациент успешно добавлен!');
          // Очищаем форму после успешного добавления
          _clearForm();
        }
        if (state is AddPatientStates.AddPatientFailure) {
          SnackbarService.showError(context, 'Ошибка: ${state.error}');
        }
        if (state is AddPatientStates.SectorsLoaded) {
          setState(() {
            sectors = state.sectors;
          });
          _loadSectorForEdit();
          }
        if (state is AddPatientStates.SectorsLoadFailed) {
          SnackbarService.showError(context, 'Ошибка загрузки участков: ${state.error}');
        }
      },
          ),
          BlocListener<AboutPatientBloc, AboutPatientStates.AboutPatientState>(
            listener: (context, state) {
              if (state is AboutPatientStates.PatientUpdateSuccess) {
                SnackbarService.showSuccess(context, state.message);
                Navigator.pop(context); // Возвращаемся назад после успешного обновления
              }
              if (state is AboutPatientStates.PatientUpdateFailure) {
                SnackbarService.showError(context, 'Ошибка: ${state.error}');
              }
            },
          ),
        ],
      child: BlocBuilder<AddPatientBloc, AddPatientStates.AddPatientState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Color(0xFF1C6BA4),
              title: Text('Редактирование пациента',style: GoogleFonts.montserrat(fontSize: 17,
              color: ColorStyles.whiteColor,fontWeight: FontWeight.w500,
                ),
              ),
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
            ),
            ),
            body: (state is AddPatientStates.AddPatientLoading || isLoading) 
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
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
                        Text('Контактный телефон',style: GoogleFonts.montserrat(fontSize: 12,fontWeight: FontWeight.w600,color: ColorStyles.blackColor),)
                      ],
                    ),
                    const SizedBox(height: 4),
                    AddTextField(
                      controller: _contactController,
                      hintText: '+7 (___) ___-__-__',
                      inputFormatters: [phoneMaskFormatter],
                      keyboardType: TextInputType.phone,
                    ),
                  ],
                ),
              ),
              
      
              
              
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
      final patientData = <String, dynamic>{
        'user_id': widget.patientId,
        'last_name': _surnameController.text,
        'first_name': _nameController.text,
        'middle_name': _middleNameController.text.isEmpty ? '' : _middleNameController.text,
        'iin': _iinController.text,
        'birth_date': _convertDateFormat(_birthController.text),
        if (_heightController.text.isNotEmpty) 'height_cm': int.tryParse(_heightController.text),
        if (_weightController.text.isNotEmpty) 'weight_kg': int.tryParse(_weightController.text),
        if (selectedGender != null) 'gender': selectedGender,
        'address': _addressController.text,
        if (_emailController.text.isNotEmpty) 'mail': _emailController.text,
        'phone_number': _contactController.text,
        'relative_phone_number': null,
        if (_arterialdavlenie.text.isNotEmpty) 'blood_pressure': _arterialdavlenie.text,
        if (_levelsugar.text.isNotEmpty) 'sugar_level': double.tryParse(_levelsugar.text),
        if (_heartbeat.text.isNotEmpty) 'heart_rate': int.tryParse(_heartbeat.text),
        'diseases': selectedDisease != null ? [selectedDisease == 'Артериальная гипертензия' ? 1 : selectedDisease == 'Хроническая сердечная недостаточность' ? 2 : 3] : [],
        if (selectedSector?.sectorId != null) 'sector_id': selectedSector?.sectorId,
        if (_loadedMedStaffId != null) 'med_staff_id': _loadedMedStaffId,
      };
      
      patientData.removeWhere((key, value) => value == null);
      
      context.read<AboutPatientBloc>().add(
        AboutPatientEvents.UpdatePatientEvent(
          patientId: widget.patientId,
          patientData: patientData,
        ),
      );
    },
    child: const Text('Сохранить изменения'),
  ),
),
          const SizedBox(height: 20),

            ],
          ),
        ),
      ),
          );
        },
      ),
      ),
    );
  }
}