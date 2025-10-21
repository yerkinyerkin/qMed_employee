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
  bool? hasCVD;
  bool? hasRetinopathy;
  bool? takesStatin;
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
  final _familyContactController = TextEditingController();
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

  bool hasHypertension = false;
  bool hasHeartFailure = false; 
  bool hasDiabetes = false;
  @override
  void initState() {
    super.initState();
    context.read<AddPatientBloc>().add(LoadSectors());
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
    _familyContactController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddPatientBloc, AddPatientState>(
      listener: (context, state) {
        if (state is AddPatientSuccess) {
          // Показать успешное сообщение
          SnackbarService.showSuccess(context, 'Пациент успешно добавлен!');
          // Вернуться на предыдущий экран
          Navigator.pop(context);
        }
        if (state is AddPatientFailure) {
          // Показать ошибку
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
                    const SizedBox(height: 8),
                    
                    Row(
                      children: [
                        Text('Контактный телефон родственника',style: GoogleFonts.montserrat(fontSize: 12,fontWeight: FontWeight.w600,color: ColorStyles.blackColor),)
                      ],
                    ),
                    const SizedBox(height: 4),
                    AddTextField(controller: _familyContactController,hintText: 'Контактный телефон родственника',),
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
              
              
              // Секция 4: Заболевания
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
                        Checkbox(
                          value: hasHypertension,
                          onChanged: (bool? value) {
                            setState(() {
                              hasHypertension = value ?? false;
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
                        Checkbox(
                          value: hasHeartFailure,
                          onChanged: (bool? value) {
                            setState(() {
                              hasHeartFailure = value ?? false;
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
                        Checkbox(
                          value: hasDiabetes,
                          onChanged: (bool? value) {
                            setState(() {
                              hasDiabetes = value ?? false;
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
              
              // Секция 7: Сахарный диабет
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
                        Text('Показания последнего анализа HbA1c (гликированный гемоглобин) (%)',style: GoogleFonts.montserrat(fontSize: 12,fontWeight: FontWeight.w600,color: ColorStyles.blackColor),),
          
                    const SizedBox(height: 4),
                    AddTextField(controller: _hba1cValue,hintText: 'Например, 7.2',),
                    const SizedBox(height: 8),
          
                        Text('Дата последнего анализа HbA1c (гликированный гемоглобин)',style: GoogleFonts.montserrat(fontSize: 12,fontWeight: FontWeight.w600,color: ColorStyles.blackColor),),
                 
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
                        Text('Показания последнего анализа ЛПНП (Липопротеины Низкой Плотности)(ммоль/л)',style: GoogleFonts.montserrat(fontSize: 12,fontWeight: FontWeight.w600,color: ColorStyles.blackColor),),

                    const SizedBox(height: 4),
                    AddTextField(controller: _ldlValue,hintText: 'например, 3',),
                    const SizedBox(height: 8),
                        Text('Дата последнего анализа ЛПНП (Липопротеины Низкой Плотности)',style: GoogleFonts.montserrat(fontSize: 12,fontWeight: FontWeight.w600,color: ColorStyles.blackColor),),

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
                      
                        Text('Имеется ли у пациента ССЗ (стенокардия, ОИМ, инсульт)?',style: GoogleFonts.montserrat(fontSize: 12,fontWeight: FontWeight.w600,color: ColorStyles.blackColor),),

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
                    Row(
                      children: [
                        Text('Дата последнего осмотра стоп',style: GoogleFonts.montserrat(fontSize: 12,fontWeight: FontWeight.w600,color: ColorStyles.blackColor),)
                      ],
                    ),
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
                    Text(
  'Есть ли у пациента диабетическая ретинопатия?',
  style: GoogleFonts.montserrat(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: ColorStyles.blackColor,
  ),
),
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
                    Text(
                        'Дата последнего обследования глазного дна на ретинопатию',style: GoogleFonts.montserrat(fontSize: 12,fontWeight: FontWeight.w600,color: ColorStyles.blackColor)
                     
                    ),
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
                    Row(
                      children: [
                        Text('Принимает ли пациент статин?',style: GoogleFonts.montserrat(fontSize: 12,fontWeight: FontWeight.w600,color: ColorStyles.blackColor),)
                      ],
                    ),
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
                    Row(
                      children: [
                        Text('Дата последнего анализа САК',style: GoogleFonts.montserrat(fontSize: 12,fontWeight: FontWeight.w600,color: ColorStyles.blackColor),)
                      ],
                    ),
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
        uchastok: selectedSector?.address,
        surname: _surnameController.text,
        name: _nameController.text,
        middleName: _middleNameController.text.isEmpty ? null : _middleNameController.text,
        iin: _iinController.text,
        birthDate: _birthController.text,
        gender: selectedGender ?? '',
        address: _addressController.text,
        email: _mailController.text.isEmpty ? null : _mailController.text,
        contactPhone: _contactController.text,
        familyContactPhone: _familyContactController.text.isEmpty ? null : _familyContactController.text,
        height: _heightController.text.isEmpty ? null : double.tryParse(_heightController.text),
        weight: _weightController.text.isEmpty ? null : double.tryParse(_weightController.text),
        bmi: bmi,
        hasHypertension: hasHypertension,
        hasHeartFailure: hasHeartFailure,
        hasDiabetes: hasDiabetes,
        arterialPressure: _arterialdavlenie.text.isEmpty ? null : _arterialdavlenie.text,
        heartbeat: _heartbeat.text.isEmpty ? null : _heartbeat.text,
        sugarLevel: _levelsugar.text.isEmpty ? null : _levelsugar.text,
        lastBPDate: _lastBPDate.text.isEmpty ? null : _lastBPDate.text,
        lastSelfManagementDate: _lastSelfManagementDate.text.isEmpty ? null : _lastSelfManagementDate.text,
        smokingStatus: smokingStatus,
        confidenceLevel: _confidenceLevel.text.isEmpty ? null : _confidenceLevel.text,
        lastConfidenceDate: _lastConfidenceDate.text.isEmpty ? null : _lastConfidenceDate.text,
        hba1cValue: _hba1cValue.text.isEmpty ? null : _hba1cValue.text,
        hba1cDate: _hba1cDate.text.isEmpty ? null : _hba1cDate.text,
        ldlValue: _ldlValue.text.isEmpty ? null : _ldlValue.text,
        ldlDate: _ldlDate.text.isEmpty ? null : _ldlDate.text,
        hasCVD: hasCVD,
        footExamDate: _footExamDate.text.isEmpty ? null : _footExamDate.text,
        hasRetinopathy: hasRetinopathy,
        retinopathyDate: _retinopathyDate.text.isEmpty ? null : _retinopathyDate.text,
        takesStatin: takesStatin,
        sakDate: _sakDate.text.isEmpty ? null : _sakDate.text,
      );
      
      // Отправить событие в bloc
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