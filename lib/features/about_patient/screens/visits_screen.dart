import 'package:flutter/material.dart';
import 'package:qmed_employee/features/about_patient/screens/edit_visit_screen.dart';
import 'package:dio/dio.dart';
import 'package:qmed_employee/core/dio_interceptor/dio_interceptor.dart';

class VisitsScreen extends StatefulWidget {
  final int patientId;
  final String? patientName;
  final String? patientIin;
  const VisitsScreen({super.key, this.patientId = 10, this.patientName, this.patientIin});

  @override
  State<VisitsScreen> createState() => _VisitsScreenState();
}

class _VisitsScreenState extends State<VisitsScreen> {
  final Dio _dio = DioInterceptor(Dio()).getDio;
  bool _loading = true;
  List<dynamic> _visits = [];
  String _patientName = '';
  String _patientIin = '';

  @override
  void initState() {
    super.initState();
    // Проставляем из навигации, если передали
    _patientName = widget.patientName ?? '';
    _patientIin = widget.patientIin ?? '';
    _loadVisits();
  }

  Future<void> _loadVisits() async {
    try {
      final res = await _dio.get('/patient/${widget.patientId}/visits', queryParameters: {'page': 1, 'size': 100});
      final data = res.data;
      if (data is List) {
        data.sort((a, b) {
          final aCreated = DateTime.tryParse(a['visit_general']?['visit']?['created_at'] ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0);
          final bCreated = DateTime.tryParse(b['visit_general']?['visit']?['created_at'] ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0);
          return bCreated.compareTo(aCreated);
        });
        setState(() {
          _visits = data;
          if (data.isNotEmpty) {
            final p = data.first['visit_general']?['visit']?['patient'] ?? {};
            final l = p['last_name'] ?? '';
            final f = p['first_name'] ?? '';
            final m = p['middle_name'] ?? '';
            _patientName = [l, f, m].where((e) => (e as String).isNotEmpty).join(' ');
            _patientIin = p['iin']?.toString() ?? '';
          }
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Визиты', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color(0xFF1C6BA4),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 10),
              child: Text(
                _patientName.isEmpty ? '—' : _patientName,
                style: const TextStyle(
                  fontSize: 18,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                _patientIin.isEmpty ? '—' : _patientIin,
                style: const TextStyle(
                  fontSize: 18,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10, top: 20, bottom: 10),
              child: Text(
                'История визитов',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
              ),
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFF2F6FC),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(flex: 3, child: Text('Дата визита', style: TextStyle(fontWeight: FontWeight.bold))),
                        Expanded(flex: 2, child: Text('Период', style: TextStyle(fontWeight: FontWeight.bold))),
                        Expanded(flex: 3, child: Text('Функции', style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                    ),
                  ),

                  ..._visits.map((visit) => _buildRow(context, visit as Map<String, dynamic>)).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _fmtDate(String? iso) {
    if (iso == null || iso.isEmpty) return '';
    try {
      final dt = DateTime.parse(iso);
      final d = dt.day.toString().padLeft(2, '0');
      final m = dt.month.toString().padLeft(2, '0');
      final y = dt.year.toString();
      return '$d.$m.$y';
    } catch (_) {
      return '';
    }
  }

  String _pluralRu(int n, String one, String few, String many) {
    final nAbs = n.abs();
    final mod10 = nAbs % 10;
    final mod100 = nAbs % 100;
    if (mod10 == 1 && mod100 != 11) return one; // 1, 21, 31 ...
    if (mod10 >= 2 && mod10 <= 4 && (mod100 < 12 || mod100 > 14)) return few; // 2-4, 22-24 ...
    return many; // остальное
  }

  String _humanizePeriod(String? iso) {
    if (iso == null || iso.isEmpty) return '';
    DateTime created;
    try {
      created = DateTime.parse(iso);
    } catch (_) {
      return '';
    }

    final now = DateTime.now();

    // Считаем месяцы с поправкой на день
    int totalMonths = (now.year - created.year) * 12 + (now.month - created.month);
    if (now.day < created.day) totalMonths -= 1;

    if (totalMonths >= 12) {
      final years = totalMonths ~/ 12;
      return '$years ' + _pluralRu(years, 'год', 'года', 'лет');
    }
    if (totalMonths >= 1) {
      return '$totalMonths ' + _pluralRu(totalMonths, 'месяц', 'месяца', 'месяцев');
    }

    final days = now.difference(created).inDays;
    if (days >= 7) {
      final weeks = days ~/ 7;
      return '$weeks ' + _pluralRu(weeks, 'неделя', 'недели', 'недель');
    }
    final safeDays = days < 0 ? 0 : days; // на будущее
    return '$safeDays ' + _pluralRu(safeDays, 'день', 'дня', 'дней');
  }

  Widget _buildRow(BuildContext context, Map<String, dynamic> visit) {
    final createdAt = visit['visit_general']?['visit']?['created_at'] as String?;
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE0E0E0))),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(flex: 3, child: Text(_fmtDate(createdAt))),
          Expanded(flex: 2, child: Text(_humanizePeriod(createdAt))),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _iconButton(
                  Icons.remove_red_eye_outlined,
                  const Color(0xFFFFF3C4),
                  onTap: () => _showVisitDetails(context, visit),
                ),
                _iconButton(
                  Icons.edit_outlined,
                  const Color(0xFFD6E9FF),
                  onTap: () {
                    final visitId = visit['visit_general']?['visit']?['visit_id'] as int?;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditVisitScreen(
                          visit: {"date": _fmtDate(createdAt)},
                          patientId: widget.patientId,
                          visitId: visitId,
                        ),
                      ),
                    );
                  },
                ),
                _iconButton(Icons.delete_outline, const Color(0xFFFFD6D6)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconButton(IconData icon, Color bgColor, {VoidCallback? onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 20, color: Colors.black87),
      ),
    );
  }

  void _showVisitDetails(BuildContext context, Map<String, dynamic> visit) {
    final vg = visit['visit_general'] ?? {};
    final patient = vg['visit']?['patient'] ?? {};
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Детали визита',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _detailsField('Дата визита', _fmtDate(vg['visit']?['created_at'])),
                    _detailsField('Пациент', _fullName(patient)),
                    _detailsField('Рост (см)', (vg['height_cm']?.toString() ?? '')), 
                    _detailsField('Вес (кг)', (vg['weight_kg']?.toString() ?? '')),
                    _detailsField('ИМТ', (vg['bmi']?.toString() ?? '')),
                    _detailsField('Артериальное давление', _bp(vg['systolic_bp'], vg['diastolic_bp'])),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Закрыть'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _bp(dynamic sys, dynamic dia) {
    final s = sys?.toString() ?? '';
    final d = dia?.toString() ?? '';
    if (s.isEmpty && d.isEmpty) return '';
    return '$s/$d мм рт.ст.';
  }

  String _fullName(Map p) {
    final f = p['first_name'] ?? '';
    final l = p['last_name'] ?? '';
    final m = p['middle_name'] ?? '';
    return [l, f, m].where((e) => (e as String).isNotEmpty).join(' ');
  }

  Widget _detailsField(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8EEF7)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: const TextStyle(color: Colors.black54, fontSize: 16),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0E1A2B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
