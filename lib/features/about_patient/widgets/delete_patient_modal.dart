import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../logic/bloc/about_patient_bloc.dart';
import '../logic/bloc/about_patient_event.dart';
import '../logic/bloc/about_patient_state.dart';
import 'package:qmed_employee/core/common/snackbar_service.dart';

class DeletePatientModal extends StatefulWidget {
  final int patientId;
  final AboutPatientBloc bloc;
  
  const DeletePatientModal({
    super.key, 
    required this.patientId,
    required this.bloc,
  });

  @override
  State<DeletePatientModal> createState() => _DeletePatientModalState();
}

class _DeletePatientModalState extends State<DeletePatientModal> {
  int? selectedIndex;
  final TextEditingController _causeOfDeathController = TextEditingController();

@override
Widget build(BuildContext context) {
  final reasons = [
    'Смертность',
    'Открепление от поликлиники',
    'Отказ от участия',
    'Экстренная госпитализация',
  ];

  return Container(
    width: double.infinity,
    height: 400,
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Выберите причину',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 21,
          ),
        ),
        const SizedBox(height: 16),

        SizedBox(
          height: 260,
          child: ListView.builder(
            itemCount: reasons.length,
            itemBuilder: (context, index) {
              final isSelected = selectedIndex == index;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                  // Если выбран "Смертность", открываем модальное окно для ввода причины
                  if (index == 0) {
                    _showCauseOfDeathDialog(context);
                  }
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.symmetric(
                      vertical: 14, horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected ? Color(0xFF1C6BA4) : Colors.grey.shade300,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color: isSelected
                        ? Colors.blue.withOpacity(0.1)
                        : Colors.transparent,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          reasons[index],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color:
                                isSelected ? Color(0xFF1C6BA4) : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        
        SizedBox(
  width: double.infinity,
  height: 40,
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF1C6BA4),
      foregroundColor: Colors.white, 
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
    onPressed: () {
      if (selectedIndex == null) {
        SnackbarService.showError(context, 'Выберите причину удаления');
        return;
      }
      
      // removal_reason_id = selectedIndex + 1 (0 -> 1, 1 -> 2, и т.д.)
      final removalReasonId = selectedIndex! + 1;
      String? causeOfDeath;
      
      // Если выбрана "Смертность" (index 0), берем текст из поля
      if (selectedIndex == 0) {
        causeOfDeath = _causeOfDeathController.text.trim();
        if (causeOfDeath == null || causeOfDeath.isEmpty) {
          SnackbarService.showError(context, 'Введите причину смерти');
          return;
        }
      }
      
      // Вызываем BLoC Event
      widget.bloc.add(
        DeletePatientEvent(
          patientId: widget.patientId,
          removalReasonId: removalReasonId,
          causeOfDeath: causeOfDeath,
        ),
      );
      
      Navigator.pop(context); // Закрыть модалку
    },
    child: const Text('Выбрать'),
  ),
),

       const SizedBox(height: 16),

      ],
    ),
  );
}

  void _showCauseOfDeathDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('Причина смерти'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Введите причину смерти',
              hintText: 'Например: сахарный диабет',
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  setState(() {
                    _causeOfDeathController.text = controller.text.trim();
                  });
                  Navigator.pop(dialogContext);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1C6BA4),
                foregroundColor: Colors.white,
              ),
              child: const Text('Сохранить'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _causeOfDeathController.dispose();
    super.dispose();
  }
}