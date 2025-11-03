import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'package:qmed_employee/core/dio_interceptor/dio_interceptor.dart';
import 'package:qmed_employee/core/common/snackbar_service.dart';
import 'package:qmed_employee/core/const/color_styles.dart';
import 'package:qmed_employee/features/add_patient/widgets/add_text_field.dart';

class AddVisitScreen extends StatefulWidget {
  final int patientId;
  
  const AddVisitScreen({super.key, required this.patientId});

  @override
  State<AddVisitScreen> createState() => _AddVisitScreenState();
}

class _AddVisitScreenState extends State<AddVisitScreen> {
  Dio get dio => DioInterceptor(Dio()).getDio;
  
  bool _loading = true;
  int? _diseaseId;
  String? _diseaseName;
  
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _systolicBPController = TextEditingController();
  final _diastolicBPController = TextEditingController();
  final _lastBPDate = TextEditingController();
  final _lastSelfManagementDate = TextEditingController();
  final _confidenceLevel = TextEditingController();
  final _lastConfidenceDate = TextEditingController();
  final _ldlValue = TextEditingController();
  final _ldlDate = TextEditingController();
  final _smokingStatusAssessmentDate = TextEditingController();
  final _smokingCessationCounselingDate = TextEditingController();
  final _cholesterolValue = TextEditingController();
  final _cholesterolDate = TextEditingController();
  
  final _efValue = TextEditingController();
  final _echoDate = TextEditingController();
  final _hospitalizationDate = TextEditingController();
  final _fluVaccinationDate = TextEditingController();
  final _egfrValue = TextEditingController();
  
  final _hba1cValue = TextEditingController();
  final _hba1cDate = TextEditingController();
  final _footExamDate = TextEditingController();
  final _retinopathyDate = TextEditingController();
  final _sakDate = TextEditingController();

  double? bmi;
  String? smokingStatus;
  String? hypertensionRiskLevel;
  
  String? nyhaClass;
  bool? takesBetaBlockers;
  bool? takesACEInhibitor;
  bool? takesAldosteroneAntagonists;
  bool? hasEchoECGStudy;
  bool? hasLeftVentricularDysfunction;
  
  bool? hasCVD;
  bool? hasRetinopathy;
  bool? takesStatin;

  @override
  void initState() {
    super.initState();
    _loadPatientDisease();
  }

  Future<void> _loadPatientDisease() async {
    try {
      final response = await dio.get('/patient/${widget.patientId}');
      final data = response.data;
      if (data['diseases'] != null && data['diseases'].isNotEmpty) {
        final disease = data['diseases'][0];
        setState(() {
          _diseaseId = disease['disease_id'];
          _diseaseName = disease['name'];
          _loading = false;
        });
      } else {
        setState(() => _loading = false);
      }
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _systolicBPController.dispose();
    _diastolicBPController.dispose();
    _lastBPDate.dispose();
    _lastSelfManagementDate.dispose();
    _confidenceLevel.dispose();
    _lastConfidenceDate.dispose();
    _ldlValue.dispose();
    _ldlDate.dispose();
    _smokingStatusAssessmentDate.dispose();
    _smokingCessationCounselingDate.dispose();
    _cholesterolValue.dispose();
    _cholesterolDate.dispose();
    _efValue.dispose();
    _echoDate.dispose();
    _hospitalizationDate.dispose();
    _fluVaccinationDate.dispose();
    _egfrValue.dispose();
    _hba1cValue.dispose();
    _hba1cDate.dispose();
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
        final heightInMeters = height / 100;
        bmi = weight / (heightInMeters * heightInMeters);
        setState(() {});
      }
    }
  }

  Color _getBMIColor(double bmi) {
    if (bmi < 18.5) return Colors.blue;
    if (bmi < 25) return Colors.green;
    if (bmi < 30) return Colors.orange;
    return Colors.red;
  }

  String? _toIsoFromDdMmYyyy(String text) {
    if (text.isEmpty) return null;
    try {
      final parts = text.split('.');
      if (parts.length != 3) return null;
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      final dt = DateTime.utc(year, month, day);
      return dt.toIso8601String();
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0xFF1C6BA4),
          title: Text(
            'Добавить визит',
            style: GoogleFonts.montserrat(
              fontSize: 17,
              color: ColorStyles.whiteColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C6BA4),
        title: Text(
          'Добавить визит',
          style: GoogleFonts.montserrat(
            fontSize: 17,
            color: ColorStyles.whiteColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Основная информация о визите
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF6FC),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Рост, вес слева и ИМТ справа в одном ряду
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Рост (см)',
                                    style: GoogleFonts.montserrat(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: ColorStyles.blackColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              AddTextField(
                                controller: _heightController,
                                hintText: 'Введите рост',
                                keyboardType: TextInputType.number,
                                onChanged: (value) => calculateBMI(),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    'Вес (кг)',
                                    style: GoogleFonts.montserrat(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: ColorStyles.blackColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              AddTextField(
                                controller: _weightController,
                                hintText: 'Введите вес',
                                keyboardType: TextInputType.number,
                                onChanged: (value) => calculateBMI(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        SizedBox(
                          width: 120,
                          height: 100,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: Center(
                              child: Text(
                                bmi != null ? bmi!.toStringAsFixed(1) : '0',
                                style: GoogleFonts.montserrat(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: bmi != null ? _getBMIColor(bmi!) : Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Систолическое АД
                    Row(
                      children: [
                        Text(
                          'Систолическое АД',
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: ColorStyles.blackColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    AddTextField(
                      controller: _systolicBPController,
                      hintText: '0',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 8),

                    // Диастолическое АД
                    Row(
                      children: [
                        Text(
                          'Диастолическое АД',
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: ColorStyles.blackColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    AddTextField(
                      controller: _diastolicBPController,
                      hintText: '0',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 8),

                    // Дата последнего измерения АД
                    Row(
                      children: [
                        Text(
                          'Дата последнего измерения АД',
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: ColorStyles.blackColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    AddTextField(
                      controller: _lastBPDate,
                      hintText: 'дд.мм.гггг',
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          _lastBPDate.text = '${picked.day.toString().padLeft(2, '0')}.${picked.month.toString().padLeft(2, '0')}.${picked.year}';
                        }
                      },
                    ),
                    const SizedBox(height: 8),

                    // Дата последней цели по самоменеджменту
                    Row(
                      children: [
                        Text(
                          'Дата последней цели по самоменеджменту',
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: ColorStyles.blackColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    AddTextField(
                      controller: _lastSelfManagementDate,
                      hintText: 'дд.мм.гггг',
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          _lastSelfManagementDate.text = '${picked.day.toString().padLeft(2, '0')}.${picked.month.toString().padLeft(2, '0')}.${picked.year}';
                        }
                      },
                    ),
                    const SizedBox(height: 8),

                    // Уровень уверенности
                    Row(
                      children: [
                        Text(
                          'Уровень уверенности (от 1 до 10)',
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: ColorStyles.blackColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    AddTextField(
                      controller: _confidenceLevel,
                      hintText: '0',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 8),

                    // Дата последней оценки уровня уверенности
                    Row(
                      children: [
                        Text(
                          'Дата последней оценки уровня уверенности',
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: ColorStyles.blackColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    AddTextField(
                      controller: _lastConfidenceDate,
                      hintText: 'дд.мм.гггг',
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          _lastConfidenceDate.text = '${picked.day.toString().padLeft(2, '0')}.${picked.month.toString().padLeft(2, '0')}.${picked.year}';
                        }
                      },
                    ),
                  ],
                ),
              ),

              // Секция в зависимости от заболевания
              if (_diseaseId == 1) _buildHypertensionSection(),
              if (_diseaseId == 2) _buildHeartFailureSection(),
              if (_diseaseId == 3) _buildDiabetesSection(),

              // Кнопка применить
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1C6BA4),
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    try {
                      Map<String, dynamic> body;
                      String endpoint;

                      // АГ (disease_id: 1)
                      if (_diseaseId == 1) {
                        final riskFromRadio = () {
                          switch (hypertensionRiskLevel) {
                            case 'Нормальное АД':
                              return 0;
                            case 'Степень 1':
                              return 1;
                            case 'Степень 2':
                              return 2;
                            case 'Степень 3':
                              return 3;
                          }
                          return null;
                        }();

                        body = {
                          'visit_general': {
                            if (_heightController.text.isNotEmpty) 'height_cm': int.tryParse(_heightController.text),
                            if (_weightController.text.isNotEmpty) 'weight_kg': int.tryParse(_weightController.text),
                            if (bmi != null) 'bmi': double.tryParse(bmi!.toStringAsFixed(1)) ?? bmi,
                            if (_systolicBPController.text.isNotEmpty) 'systolic_bp': int.tryParse(_systolicBPController.text),
                            if (_diastolicBPController.text.isNotEmpty) 'diastolic_bp': int.tryParse(_diastolicBPController.text),
                            if (_toIsoFromDdMmYyyy(_lastBPDate.text) != null) 'bp_measurement_date': _toIsoFromDdMmYyyy(_lastBPDate.text),
                            if (_toIsoFromDdMmYyyy(_lastSelfManagementDate.text) != null) 'self_management_goal_date': _toIsoFromDdMmYyyy(_lastSelfManagementDate.text),
                            if (smokingStatus != null) 'smoking_status': smokingStatus == 'Да',
                            if (_toIsoFromDdMmYyyy(_smokingStatusAssessmentDate.text) != null) 'smoking_status_assessment_date': _toIsoFromDdMmYyyy(_smokingStatusAssessmentDate.text),
                            if (_toIsoFromDdMmYyyy(_smokingCessationCounselingDate.text) != null) 'smoking_cessation_counseling_date': _toIsoFromDdMmYyyy(_smokingCessationCounselingDate.text),
                            if (_confidenceLevel.text.isNotEmpty) 'self_confidence_level': int.tryParse(_confidenceLevel.text),
                            if (_toIsoFromDdMmYyyy(_lastConfidenceDate.text) != null) 'self_confidence_assessment_date': _toIsoFromDdMmYyyy(_lastConfidenceDate.text),
                          },
                          if (_ldlValue.text.isNotEmpty) 'ldl': double.tryParse(_ldlValue.text) ?? int.tryParse(_ldlValue.text),
                          if (_toIsoFromDdMmYyyy(_ldlDate.text) != null) 'ldl_date': _toIsoFromDdMmYyyy(_ldlDate.text),
                          if (_cholesterolValue.text.isNotEmpty) 'cholesterol': double.tryParse(_cholesterolValue.text) ?? int.tryParse(_cholesterolValue.text),
                          if (_toIsoFromDdMmYyyy(_cholesterolDate.text) != null) 'cholesterol_date': _toIsoFromDdMmYyyy(_cholesterolDate.text),
                          if (riskFromRadio != null) 'risk_level': riskFromRadio,
                        };
                        endpoint = '/patient/${widget.patientId}/visit-hypertension';
                      }
                      // ХСН (disease_id: 2)
                      else if (_diseaseId == 2) {
                        body = {
                          'visit_general': {
                            if (_heightController.text.isNotEmpty) 'height_cm': int.tryParse(_heightController.text),
                            if (_weightController.text.isNotEmpty) 'weight_kg': int.tryParse(_weightController.text),
                            if (bmi != null) 'bmi': double.tryParse(bmi!.toStringAsFixed(1)) ?? bmi,
                            if (_systolicBPController.text.isNotEmpty) 'systolic_bp': int.tryParse(_systolicBPController.text),
                            if (_diastolicBPController.text.isNotEmpty) 'diastolic_bp': int.tryParse(_diastolicBPController.text),
                            if (_toIsoFromDdMmYyyy(_lastBPDate.text) != null) 'bp_measurement_date': _toIsoFromDdMmYyyy(_lastBPDate.text),
                            if (_toIsoFromDdMmYyyy(_lastSelfManagementDate.text) != null) 'self_management_goal_date': _toIsoFromDdMmYyyy(_lastSelfManagementDate.text),
                            if (smokingStatus != null) 'smoking_status': smokingStatus == 'Да',
                            if (_confidenceLevel.text.isNotEmpty) 'self_confidence_level': int.tryParse(_confidenceLevel.text),
                            if (_toIsoFromDdMmYyyy(_lastConfidenceDate.text) != null) 'self_confidence_assessment_date': _toIsoFromDdMmYyyy(_lastConfidenceDate.text),
                          },
                          // Добавим специфичные для ХСН поля
                        };
                        endpoint = '/patient/${widget.patientId}/visit-heart-failure';
                      }
                      // СД (disease_id: 3)
                      else if (_diseaseId == 3) {
                        body = {
                          'visit_general': {
                            if (_heightController.text.isNotEmpty) 'height_cm': int.tryParse(_heightController.text),
                            if (_weightController.text.isNotEmpty) 'weight_kg': int.tryParse(_weightController.text),
                            if (bmi != null) 'bmi': double.tryParse(bmi!.toStringAsFixed(1)) ?? bmi,
                            if (_systolicBPController.text.isNotEmpty) 'systolic_bp': int.tryParse(_systolicBPController.text),
                            if (_diastolicBPController.text.isNotEmpty) 'diastolic_bp': int.tryParse(_diastolicBPController.text),
                            if (_toIsoFromDdMmYyyy(_lastBPDate.text) != null) 'bp_measurement_date': _toIsoFromDdMmYyyy(_lastBPDate.text),
                            if (_toIsoFromDdMmYyyy(_lastSelfManagementDate.text) != null) 'self_management_goal_date': _toIsoFromDdMmYyyy(_lastSelfManagementDate.text),
                            if (smokingStatus != null) 'smoking_status': smokingStatus == 'Да',
                            if (_confidenceLevel.text.isNotEmpty) 'self_confidence_level': int.tryParse(_confidenceLevel.text),
                            if (_toIsoFromDdMmYyyy(_lastConfidenceDate.text) != null) 'self_confidence_assessment_date': _toIsoFromDdMmYyyy(_lastConfidenceDate.text),
                          },
                          // Добавим специфичные для СД поля
                        };
                        endpoint = '/patient/${widget.patientId}/visit-diabetes';
                      } else {
                        SnackbarService.showError(context, 'Неизвестный тип заболевания');
                        return;
                      }

                      await dio.post(endpoint, data: body);
                      if (!mounted) return;
                      SnackbarService.showSuccess(context, 'Визит добавлен');
                      Navigator.pop(context);
                    } catch (e) {
                      if (!mounted) return;
                      SnackbarService.showError(context, 'Ошибка добавления визита: $e');
                    }
                  },
                  child: const Text('Сохранить'),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHypertensionSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF6FC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Артериальная гипертензия',
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: ColorStyles.blackColor,
            ),
          ),
          const SizedBox(height: 16),

          // Статус курения
          Row(
            children: [
              Text(
                'Статус курения?',
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: ColorStyles.blackColor,
                ),
              ),
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
              const Text('Да'),
              Radio<String>(
                value: 'Нет',
                groupValue: smokingStatus,
                onChanged: (String? value) {
                  setState(() {
                    smokingStatus = value;
                  });
                },
              ),
              const Text('Нет'),
            ],
          ),
          const SizedBox(height: 16),

          Text(
            'Показания последнего анализа ЛПНП (ммоль/л)',
            style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w600, color: ColorStyles.blackColor),
          ),
          const SizedBox(height: 4),
          AddTextField(controller: _ldlValue, hintText: 'Например, 3.2'),
          const SizedBox(height: 8),
          Text(
            'Дата последнего анализа ЛПНП',
            style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w600, color: ColorStyles.blackColor),
          ),
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
                _ldlDate.text = '${picked.day.toString().padLeft(2, '0')}.${picked.month.toString().padLeft(2, '0')}.${picked.year}';
              }
            },
          ),
          const SizedBox(height: 8),

          Text(
            'Показания последнего анализа общего холестерина (ммоль/л)',
            style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w600, color: ColorStyles.blackColor),
          ),
          const SizedBox(height: 4),
          AddTextField(controller: _cholesterolValue, hintText: 'Например, 5.5'),
          const SizedBox(height: 8),
          Text(
            'Дата последнего анализа общего холестерина',
            style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w600, color: ColorStyles.blackColor),
          ),
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
                _cholesterolDate.text = '${picked.day.toString().padLeft(2, '0')}.${picked.month.toString().padLeft(2, '0')}.${picked.year}';
              }
            },
          ),
          const SizedBox(height: 16),

          Text(
            'Степень риска (АГ)',
            style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w600, color: ColorStyles.blackColor),
          ),
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
              const Text('Нормальное АД'),
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
              const Text('Степень 1'),
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
              const Text('Степень 2'),
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
              const Text('Степень 3'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeartFailureSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF6FC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Хроническая сердечная недостаточность',
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: ColorStyles.blackColor,
            ),
          ),
          const SizedBox(height: 16),

          // Статус курения
          Row(
            children: [
              Text(
                'Статус курения?',
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: ColorStyles.blackColor,
                ),
              ),
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
              const Text('Да'),
              Radio<String>(
                value: 'Нет',
                groupValue: smokingStatus,
                onChanged: (String? value) {
                  setState(() {
                    smokingStatus = value;
                  });
                },
              ),
              const Text('Нет'),
            ],
          ),
          const SizedBox(height: 16),

          // NYHA
          Text(
            'NYHA',
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: ColorStyles.blackColor,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Radio<String>(
                value: 'I класс',
                groupValue: nyhaClass,
                onChanged: (String? value) {
                  setState(() {
                    nyhaClass = value;
                  });
                },
              ),
              const Text('I класс'),
              Radio<String>(
                value: 'II класс',
                groupValue: nyhaClass,
                onChanged: (String? value) {
                  setState(() {
                    nyhaClass = value;
                  });
                },
              ),
              const Text('II класс'),
            ],
          ),
          Row(
            children: [
              Radio<String>(
                value: 'III класс',
                groupValue: nyhaClass,
                onChanged: (String? value) {
                  setState(() {
                    nyhaClass = value;
                  });
                },
              ),
              const Text('III класс'),
              Radio<String>(
                value: 'IV класс',
                groupValue: nyhaClass,
                onChanged: (String? value) {
                  setState(() {
                    nyhaClass = value;
                  });
                },
              ),
              const Text('IV класс'),
            ],
          ),
          const SizedBox(height: 16),

          // Последний показатель ФВ
          Text(
            'Последний показатель ФВ по эхокардиографии',
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: ColorStyles.blackColor,
            ),
          ),
          const SizedBox(height: 4),
          AddTextField(
            controller: _efValue,
            hintText: 'Введите показатель в %',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 8),

          // Дата последней эхокардиографии
          Text(
            'Дата последней эхокардиографии',
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: ColorStyles.blackColor,
            ),
          ),
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
                _echoDate.text = '${picked.day.toString().padLeft(2, '0')}.${picked.month.toString().padLeft(2, '0')}.${picked.year}';
              }
            },
          ),
          const SizedBox(height: 16),

          // Бета-блокаторы
          Text(
            'Принимает ли пациент бета-блокаторы?',
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
                groupValue: takesBetaBlockers,
                onChanged: (bool? value) {
                  setState(() {
                    takesBetaBlockers = value;
                  });
                },
              ),
              const Text('Да'),
              Radio<bool>(
                value: false,
                groupValue: takesBetaBlockers,
                onChanged: (bool? value) {
                  setState(() {
                    takesBetaBlockers = value;
                  });
                },
              ),
              const Text('Нет'),
            ],
          ),
          const SizedBox(height: 8),

          // Ингибитор АПФ или БРА
          Text(
            'Принимает ли пациент ингибитор АПФ или БРА?',
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
                groupValue: takesACEInhibitor,
                onChanged: (bool? value) {
                  setState(() {
                    takesACEInhibitor = value;
                  });
                },
              ),
              const Text('Да'),
              Radio<bool>(
                value: false,
                groupValue: takesACEInhibitor,
                onChanged: (bool? value) {
                  setState(() {
                    takesACEInhibitor = value;
                  });
                },
              ),
              const Text('Нет'),
            ],
          ),
          const SizedBox(height: 8),

          // Антагонисты альдостерона
          Row(
            children: [
              Expanded(
                child: Text(
                  'Принимает ли пациент антагонисты альдостерона? (например, спиронолактон)',
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: ColorStyles.blackColor,
                  ),
                ),
              ),
            ],
          ),
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
              const Text('Да'),
              Radio<bool>(
                value: false,
                groupValue: takesAldosteroneAntagonists,
                onChanged: (bool? value) {
                  setState(() {
                    takesAldosteroneAntagonists = value;
                  });
                },
              ),
              const Text('Нет'),
            ],
          ),
          const SizedBox(height: 16),

          // Дата последней госпитализации
          Text(
            'Дата последней госпитализации',
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: ColorStyles.blackColor,
            ),
          ),
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
                _hospitalizationDate.text = '${picked.day.toString().padLeft(2, '0')}.${picked.month.toString().padLeft(2, '0')}.${picked.year}';
              }
            },
          ),
          const SizedBox(height: 8),

          // Дата последней вакцинации против гриппа
          Text(
            'Дата последней вакцинации против гриппа',
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: ColorStyles.blackColor,
            ),
          ),
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
                _fluVaccinationDate.text = '${picked.day.toString().padLeft(2, '0')}.${picked.month.toString().padLeft(2, '0')}.${picked.year}';
              }
            },
          ),
          const SizedBox(height: 8),

          // Показания последнего рСКФ
          Text(
            'Показания последнего рСКФ',
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: ColorStyles.blackColor,
            ),
          ),
          const SizedBox(height: 4),
          AddTextField(
            controller: _egfrValue,
            hintText: 'Введите класс',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),

          // ЭхоЭКГ исследование
          Row(
            children: [
              Expanded(
                child: Text(
                  'Проводилось ли пациенту с сердечной недостаточностью исследование ЭхоЭКГ во время диагностирования?',
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: ColorStyles.blackColor,
                  ),
                ),
              ),
            ],
          ),
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
              const Text('Да'),
              Radio<bool>(
                value: false,
                groupValue: hasEchoECGStudy,
                onChanged: (bool? value) {
                  setState(() {
                    hasEchoECGStudy = value;
                  });
                },
              ),
              const Text('Нет'),
            ],
          ),
          const SizedBox(height: 8),

          // Дисфункция левого желудочка
          Row(
            children: [
              Expanded(
                child: Text(
                  'Имеется ли у пациента дисфункция левого желудочка с систолической дисфункцией и выбросом фракции < 40%?',
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: ColorStyles.blackColor,
                  ),
                ),
              ),
            ],
          ),
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
              const Text('Да'),
              Radio<bool>(
                value: false,
                groupValue: hasLeftVentricularDysfunction,
                onChanged: (bool? value) {
                  setState(() {
                    hasLeftVentricularDysfunction = value;
                  });
                },
              ),
              const Text('Нет'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDiabetesSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF6FC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Сахарный диабет',
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: ColorStyles.blackColor,
            ),
          ),
          const SizedBox(height: 16),

          // Статус курения
          Row(
            children: [
              Text(
                'Статус курения?',
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: ColorStyles.blackColor,
                ),
              ),
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
              const Text('Да'),
              Radio<String>(
                value: 'Нет',
                groupValue: smokingStatus,
                onChanged: (String? value) {
                  setState(() {
                    smokingStatus = value;
                  });
                },
              ),
              const Text('Нет'),
            ],
          ),
          const SizedBox(height: 16),

          // ЛПНП
          Text(
            'Показания последнего анализа ЛПНП (Липопротеины Низкой Плотности)(ммоль/л)',
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: ColorStyles.blackColor,
            ),
          ),
          const SizedBox(height: 4),
          AddTextField(
            controller: _ldlValue,
            hintText: 'Например, 3',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 8),

          // Дата ЛПНП
          Text(
            'Дата последнего анализа ЛПНП (Липопротеины Низкой Плотности)',
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: ColorStyles.blackColor,
            ),
          ),
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
                _ldlDate.text = '${picked.day.toString().padLeft(2, '0')}.${picked.month.toString().padLeft(2, '0')}.${picked.year}';
              }
            },
          ),
          const SizedBox(height: 16),

          // HbA1c
          Text(
            'Показания последнего анализа HbA1c (гликированный гемоглобин) (%)',
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: ColorStyles.blackColor,
            ),
          ),
          const SizedBox(height: 4),
          AddTextField(
            controller: _hba1cValue,
            hintText: 'Например, 7.2',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 8),

          // Дата HbA1c
          Text(
            'Дата последнего анализа HbA1c (гликированный гемоглобин)',
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: ColorStyles.blackColor,
            ),
          ),
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
                _hba1cDate.text = '${picked.day.toString().padLeft(2, '0')}.${picked.month.toString().padLeft(2, '0')}.${picked.year}';
              }
            },
          ),
          const SizedBox(height: 16),

          // ССЗ
          Row(
            children: [
              Expanded(
                child: Text(
                  'Имеется ли у пациента ССЗ (стенокардия, ОИМ, инсульт)?',
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: ColorStyles.blackColor,
                  ),
                ),
              ),
            ],
          ),
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
              const Text('Да'),
              Radio<bool>(
                value: false,
                groupValue: hasCVD,
                onChanged: (bool? value) {
                  setState(() {
                    hasCVD = value;
                  });
                },
              ),
              const Text('Нет'),
            ],
          ),
          const SizedBox(height: 16),

          // Дата осмотра стопы
          Text(
            'Дата последнего осмотра стопы',
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: ColorStyles.blackColor,
            ),
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
                _footExamDate.text = '${picked.day.toString().padLeft(2, '0')}.${picked.month.toString().padLeft(2, '0')}.${picked.year}';
              }
            },
          ),
          const SizedBox(height: 16),

          // Ретинопатия
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
              const Text('Да'),
              Radio<bool>(
                value: false,
                groupValue: hasRetinopathy,
                onChanged: (bool? value) {
                  setState(() {
                    hasRetinopathy = value;
                  });
                },
              ),
              const Text('Нет'),
            ],
          ),
          const SizedBox(height: 8),

          // Дата обследования на ретинопатию
          Text(
            'Дата последнего обследования глазного дна на ретинопатию',
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: ColorStyles.blackColor,
            ),
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
                _retinopathyDate.text = '${picked.day.toString().padLeft(2, '0')}.${picked.month.toString().padLeft(2, '0')}.${picked.year}';
              }
            },
          ),
          const SizedBox(height: 16),

          // Статин
          Text(
            'Принимает ли пациент статин?',
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
                groupValue: takesStatin,
                onChanged: (bool? value) {
                  setState(() {
                    takesStatin = value;
                  });
                },
              ),
              const Text('Да'),
              Radio<bool>(
                value: false,
                groupValue: takesStatin,
                onChanged: (bool? value) {
                  setState(() {
                    takesStatin = value;
                  });
                },
              ),
              const Text('Нет'),
            ],
          ),
          const SizedBox(height: 8),

          // Дата анализа САК
          Text(
            'Дата последнего анализа САК',
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: ColorStyles.blackColor,
            ),
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
                _sakDate.text = '${picked.day.toString().padLeft(2, '0')}.${picked.month.toString().padLeft(2, '0')}.${picked.year}';
              }
            },
          ),
        ],
      ),
    );
  }
}

