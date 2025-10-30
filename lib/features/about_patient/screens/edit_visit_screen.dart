import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'package:qmed_employee/core/dio_interceptor/dio_interceptor.dart';
import 'package:qmed_employee/core/common/snackbar_service.dart';
import 'package:qmed_employee/core/const/color_styles.dart';
import 'package:qmed_employee/features/add_patient/widgets/add_text_field.dart';

class EditVisitScreen extends StatefulWidget {
  final Map<String, String> visit;
  final int patientId;
  final int? visitId;
  
  const EditVisitScreen({super.key, required this.visit, required this.patientId, this.visitId});

  @override
  State<EditVisitScreen> createState() => _EditVisitScreenState();
}

class _EditVisitScreenState extends State<EditVisitScreen> {
  Dio get dio => DioInterceptor(Dio()).getDio;
  // Controllers для всех полей
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _systolicBPController = TextEditingController();
  final _diastolicBPController = TextEditingController();
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
  final _efValue = TextEditingController();
  final _echoDate = TextEditingController();
  final _hospitalizationDate = TextEditingController();
  final _fluVaccinationDate = TextEditingController();
  final _egfrValue = TextEditingController();

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
    if (widget.visitId != null) {
      _loadVisitById(widget.visitId!);
    } else {
      _loadLatestVisit();
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

  Future<void> _loadLatestVisit() async {
    try {
      final response = await dio.get('/patient/${widget.patientId}/visits', queryParameters: {
        'page': 1,
        'size': 100,
      });
      final data = response.data;
      if (data is List && data.isNotEmpty) {
        // Возьмём последний по времени элемент
        data.sort((a, b) {
          final aCreated = DateTime.tryParse(a['visit_general']?['visit']?['created_at'] ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0);
          final bCreated = DateTime.tryParse(b['visit_general']?['visit']?['created_at'] ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0);
          return aCreated.compareTo(bCreated);
        });
        final latest = data.last;
        final vg = latest['visit_general'] ?? {};
        setState(() {
          // Общие визита
          final heightCm = vg['height_cm'];
          final weightKg = vg['weight_kg'];
          if (heightCm != null) _heightController.text = heightCm.toString();
          if (weightKg != null) _weightController.text = weightKg.toString();
          final bmiValue = vg['bmi'];
          if (bmiValue != null) bmi = (bmiValue is num) ? bmiValue.toDouble() : double.tryParse(bmiValue.toString());

          final systolic = vg['systolic_bp'];
          final diastolic = vg['diastolic_bp'];
          if (systolic != null) _systolicBPController.text = systolic.toString();
          if (diastolic != null) _diastolicBPController.text = diastolic.toString();

          _lastBPDate.text = _fmtIsoDate(vg['bp_measurement_date']);
          _lastSelfManagementDate.text = _fmtIsoDate(vg['self_management_goal_date']);

          final smoke = vg['smoking_status'];
          if (smoke is bool) smokingStatus = smoke ? 'Да' : 'Нет';
          _smokingStatusAssessmentDate.text = _fmtIsoDate(vg['smoking_status_assessment_date']);
          _smokingCessationCounselingDate.text = _fmtIsoDate(vg['smoking_cessation_counseling_date']);

          final confLevel = vg['self_confidence_level'];
          if (confLevel != null) _confidenceLevel.text = confLevel.toString();
          _lastConfidenceDate.text = _fmtIsoDate(vg['self_confidence_assessment_date']);

          // АГ (ЛПНП/Холестерин/риск)
          final ldl = latest['ldl'];
          final ldlDate = latest['ldl_date'];
          final chol = latest['cholesterol'];
          final cholDate = latest['cholesterol_date'];
          final risk = latest['risk_level'];
          if (ldl != null) _ldlValue.text = ldl.toString();
          _ldlDate.text = _fmtIsoDate(ldlDate);
          if (chol != null) _cholesterolValue.text = chol.toString();
          _cholesterolDate.text = _fmtIsoDate(cholDate);
          if (risk != null) _riskLevel.text = risk.toString();
        });
      }
    } catch (e) {
      // ignore
    }
  }

  Future<void> _loadVisitById(int visitId) async {
    try {
      final response = await dio.get('/visit/$visitId');
      final latest = response.data; // ожидаем ту же структуру, что и в списке
      final vg = latest['visit_general'] ?? {};
      setState(() {
        final heightCm = vg['height_cm'];
        final weightKg = vg['weight_kg'];
        if (heightCm != null) _heightController.text = heightCm.toString();
        if (weightKg != null) _weightController.text = weightKg.toString();
        final bmiValue = vg['bmi'];
        if (bmiValue != null) bmi = (bmiValue is num) ? bmiValue.toDouble() : double.tryParse(bmiValue.toString());

        final systolic = vg['systolic_bp'];
        final diastolic = vg['diastolic_bp'];
        if (systolic != null) _systolicBPController.text = systolic.toString();
        if (diastolic != null) _diastolicBPController.text = diastolic.toString();

        _lastBPDate.text = _fmtIsoDate(vg['bp_measurement_date']);
        _lastSelfManagementDate.text = _fmtIsoDate(vg['self_management_goal_date']);

        final smoke = vg['smoking_status'];
        if (smoke is bool) smokingStatus = smoke ? 'Да' : 'Нет';
        _smokingStatusAssessmentDate.text = _fmtIsoDate(vg['smoking_status_assessment_date']);
        _smokingCessationCounselingDate.text = _fmtIsoDate(vg['smoking_cessation_counseling_date']);

        final confLevel = vg['self_confidence_level'];
        if (confLevel != null) _confidenceLevel.text = confLevel.toString();
        _lastConfidenceDate.text = _fmtIsoDate(vg['self_confidence_assessment_date']);

        final ldl = latest['ldl'];
        final ldlDate = latest['ldl_date'];
        final chol = latest['cholesterol'];
        final cholDate = latest['cholesterol_date'];
        final risk = latest['risk_level'];
        if (ldl != null) _ldlValue.text = ldl.toString();
        _ldlDate.text = _fmtIsoDate(ldlDate);
        if (chol != null) _cholesterolValue.text = chol.toString();
        _cholesterolDate.text = _fmtIsoDate(cholDate);
        if (risk != null) {
          _riskLevel.text = risk.toString();
          if (risk == 0) hypertensionRiskLevel = 'Нормальное АД';
          if (risk == 1) hypertensionRiskLevel = 'Степень 1';
          if (risk == 2) hypertensionRiskLevel = 'Степень 2';
          if (risk == 3) hypertensionRiskLevel = 'Степень 3';
        }
      });
    } catch (e) {
      // ignore
    }
  }

  String _fmtIsoDate(dynamic iso) {
    if (iso == null) return '';
    try {
      final dt = DateTime.parse(iso.toString());
      final d = dt.day.toString().padLeft(2, '0');
      final m = dt.month.toString().padLeft(2, '0');
      final y = dt.year.toString();
      return '$d.$m.$y';
    } catch (_) {
      return '';
    }
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C6BA4),
        title: Text(
          'Редактирование визита',
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

              // Секция Артериальная гипертензия
              _buildHypertensionSection(),

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
                    if (widget.visitId == null) {
                      Navigator.pop(context);
                      return;
                    }
                    final general = <String, dynamic>{
                      if (_heightController.text.isNotEmpty) 'height_cm': int.tryParse(_heightController.text),
                      if (_weightController.text.isNotEmpty) 'weight_kg': int.tryParse(_weightController.text),
                      if (bmi != null) 'bmi': double.tryParse(bmi!.toStringAsFixed(1)) ?? bmi,
                      if (_systolicBPController.text.isNotEmpty) 'systolic_bp': int.tryParse(_systolicBPController.text),
                      if (_diastolicBPController.text.isNotEmpty) 'diastolic_bp': int.tryParse(_diastolicBPController.text),
                      if (_lastBPDate.text.isNotEmpty) 'bp_measurement_date': _toIsoFromDdMmYyyy(_lastBPDate.text),
                      if (_lastSelfManagementDate.text.isNotEmpty) 'self_management_goal_date': _toIsoFromDdMmYyyy(_lastSelfManagementDate.text),
                      if (smokingStatus != null) 'smoking_status': smokingStatus == 'Да',
                      if (_smokingStatusAssessmentDate.text.isNotEmpty) 'smoking_status_assessment_date': _toIsoFromDdMmYyyy(_smokingStatusAssessmentDate.text),
                      if (_smokingCessationCounselingDate.text.isNotEmpty) 'smoking_cessation_counseling_date': _toIsoFromDdMmYyyy(_smokingCessationCounselingDate.text),
                      if (_confidenceLevel.text.isNotEmpty) 'self_confidence_level': int.tryParse(_confidenceLevel.text),
                      if (_lastConfidenceDate.text.isNotEmpty) 'self_confidence_assessment_date': _toIsoFromDdMmYyyy(_lastConfidenceDate.text),
                    };

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

                    final body = <String, dynamic>{
                      'visit_general': general,
                      if (_ldlValue.text.isNotEmpty) 'ldl': double.tryParse(_ldlValue.text) ?? int.tryParse(_ldlValue.text),
                      if (_toIsoFromDdMmYyyy(_ldlDate.text) != null) 'ldl_date': _toIsoFromDdMmYyyy(_ldlDate.text),
                      if (_cholesterolValue.text.isNotEmpty) 'cholesterol': double.tryParse(_cholesterolValue.text) ?? int.tryParse(_cholesterolValue.text),
                      if (_toIsoFromDdMmYyyy(_cholesterolDate.text) != null) 'cholesterol_date': _toIsoFromDdMmYyyy(_cholesterolDate.text),
                      if (riskFromRadio != null) 'risk_level': riskFromRadio else if (_riskLevel.text.isNotEmpty) 'risk_level': int.tryParse(_riskLevel.text),
                    };

                    try {
                      await dio.put('/visit/${widget.visitId}/hypertension', data: body);
                      if (!mounted) return;
                      SnackbarService.showSuccess(context, 'Визит сохранён');
                      Navigator.pop(context);
                    } catch (e) {
                      if (!mounted) return;
                      SnackbarService.showError(context, 'Ошибка сохранения визита');
                    }
                  },
                  child: const Text('Применить'),
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

          // Последний показатель ФВ по эхокардиографии
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
            hintText: '2',
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
            hintText: '21.09.2025',
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

          // Принимает ли пациент бета-блокаторы?
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

          // Принимает ли пациент ингибитор АПФ или БРА?
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

          // Принимает ли пациент антагонисты альдостерона?
          Text(
            'Принимает ли пациент антагонисты альдостерона? (например, спиронолактон)',
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
            hintText: '21.09.2025',
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
            hintText: '21.09.2025',
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
            hintText: '1',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),

          // Проводилось ли пациенту с сердечной недостаточностью исследование ЭхоЭКГ во время диагностирования?
          Text(
            'Проводилось ли пациенту с сердечной недостаточностью исследование ЭхоЭКГ во время диагностирования?',
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

          // Имеется ли у пациента дисфункция левого желудочка с систолической дисфункцией и выбросом фракции < 40%?
          Text(
            'Имеется ли у пациента дисфункция левого желудочка с систолической дисфункцией и выбросом фракции < 40%?',
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
          
          // HbA1c Value
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
          
          // HbA1c Date
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
          const SizedBox(height: 8),
          
          // LDL Value
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
            hintText: 'например, 3',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 8),
          
          // LDL Date
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
          
          // CVD Question
          Text(
            'Имеется ли у пациента ССЗ (стенокардия, ОИМ, инсульт)?',
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
          const SizedBox(height: 8),
          
          // Foot Exam Date
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
          const SizedBox(height: 8),
          
          // Retinopathy Question
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
          
          // Retinopathy Date
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
          const SizedBox(height: 8),
          
          // Statin Question
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
          
          // SAK Date
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

