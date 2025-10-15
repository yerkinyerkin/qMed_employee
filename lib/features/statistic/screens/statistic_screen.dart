import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class StatisticScreen extends StatefulWidget {
  const StatisticScreen({super.key});

  @override
  State<StatisticScreen> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;
  String selectedPeriod = '3'; 
  DateTime? selectedDate;
  String selectedDisease = 'ХСН';
  List<DateTime> selectedDates = [];

  final List<String> months = [
    'Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь',
    'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'
  ];

  final List<String> diseases = [
    'ХСН',
    'АГ',
    'СД',
  ];

  void _onDateSelected(DateTime date) {
    setState(() {
      if (selectedDates.contains(date)) {
        selectedDates.remove(date);
      } else if (selectedDates.length < 2) {
        selectedDates.add(date);
        selectedDates.sort();
      } else {
        selectedDates.clear();
        selectedDates.add(date);
      }
    });
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _getPeriodText() {
    if (selectedDates.isEmpty) return '';
    if (selectedDates.length == 1) {
      return 'Период ${_formatDate(selectedDates.first)}';
    }
    return 'Период ${_formatDate(selectedDates.first)} - ${_formatDate(selectedDates.last)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Статистика',
        style: GoogleFonts.montserrat(fontSize: 18,fontWeight: FontWeight.w600,color: Colors.black),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
  'Выберите период для отчета',
  style: GoogleFonts.montserrat(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  ),
),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: selectedYear,
                    style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    dropdownColor: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    items: List.generate(5, (index) {
                      int year = DateTime.now().year - 2 + index;
                      return DropdownMenuItem(
                        value: year,
                        child: Text(year.toString()),
                      );
                    }),
                    onChanged: (value) {
                      setState(() {
                        selectedYear = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: selectedMonth,
                    style: GoogleFonts.montserrat(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.black),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    dropdownColor: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    items: months.asMap().entries.map((entry) {
                      return DropdownMenuItem(
                        value: entry.key + 1,
                        child: Text(entry.value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedMonth = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedPeriod = '3';
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedPeriod == '3' ? Color(0xFF1C6BA4) : Colors.white,
                      foregroundColor: selectedPeriod == '3' ? Colors.white : Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Последние 3 месяца'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedPeriod = '6';
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedPeriod == '6' ? Color(0xFF1C6BA4) : Colors.white,
                      foregroundColor: selectedPeriod == '6' ? Colors.white : Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Последние 6 месяцев'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: _buildCustomCalendar(),
            ),
            
            if (selectedDates.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Выбрано дат ${selectedDates.length}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getPeriodText(),
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1C6BA4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            
            Text(
              'Выберите заболевание',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            
            DropdownButtonFormField<String>(
              value: selectedDisease,
              style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.circular(12),
              items: diseases.map((disease) {
                return DropdownMenuItem(
                  value: disease,
                  child: Text(disease),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedDisease = value!;
                });
              },
            ),
            const SizedBox(height: 24),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Показ статистики...')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1C6BA4),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Скачать отчет',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomCalendar() {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(selectedYear, selectedMonth, 1);
    final lastDayOfMonth = DateTime(selectedYear, selectedMonth + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday;
    
    List<DateTime> days = [];
    
    for (int i = 1; i < firstWeekday; i++) {
      days.add(DateTime(selectedYear, selectedMonth, 0 - (firstWeekday - i - 1)));
    }
    
    for (int day = 1; day <= lastDayOfMonth.day; day++) {
      days.add(DateTime(selectedYear, selectedMonth, day));
    }
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${months[selectedMonth - 1]} $selectedYear',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          Row(
            children: ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс']
                .map((day) => Expanded(
                      child: Center(
                        child: Text(
                          day,
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 8),
          
          ...List.generate((days.length / 7).ceil(), (weekIndex) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: List.generate(7, (dayIndex) {
                  final dateIndex = weekIndex * 7 + dayIndex;
                  if (dateIndex >= days.length) {
                    return const Expanded(child: SizedBox());
                  }
                  
                  final date = days[dateIndex];
                  final isCurrentMonth = date.month == selectedMonth;
                  final isSelected = selectedDates.any((selectedDate) =>
                      selectedDate.year == date.year &&
                      selectedDate.month == date.month &&
                      selectedDate.day == date.day);
                  final isToday = date.year == now.year &&
                      date.month == now.month &&
                      date.day == now.day;
                  
                  bool isInRange = false;
                  if (selectedDates.length == 2) {
                    final startDate = selectedDates.first;
                    final endDate = selectedDates.last;
                    isInRange = date.isAfter(startDate) && date.isBefore(endDate);
                  }
                  
                  return Expanded(
                    child: GestureDetector(
                      onTap: isCurrentMonth ? () => _onDateSelected(date) : null,
                      child: Container(
                        height: 40,
                        margin: const EdgeInsets.all(2),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            if (isInRange)
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFF1C6BA4).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                              ),
                            if (isSelected)
                              Container(
                                width: 36,
                                height: 36,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF1C6BA4),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            if (isToday && !isSelected)
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Color(0xFF1C6BA4), width: 2),
                                ),
                              ),
                            Text(
                              date.day.toString(),
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: isSelected
                                    ? Colors.white
                                    : isCurrentMonth
                                        ? Colors.black
                                        : Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            );
          }),
        ],
      ),
    );
  }
}
