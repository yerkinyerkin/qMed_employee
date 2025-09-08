import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qmed_employee/core/const/color_styles.dart';
import 'package:qmed_employee/features/add_patient/widgets/add_text_field.dart';

class AddPatientScreen extends StatefulWidget {
  const AddPatientScreen({super.key});

  @override
  State<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  final _uchastokController = TextEditingController();
  final _surnameController = TextEditingController();
  final _nameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _iinController = TextEditingController();
  final _birthController = TextEditingController();
  final _lengthController = TextEditingController();
  final _weightController = TextEditingController();
  final _genderController = TextEditingController();
  final _addressController = TextEditingController();
  final _mailController = TextEditingController();
  final _contactController = TextEditingController();
  final _familyContactController = TextEditingController();

  @override
  void dispose() {
    _uchastokController.dispose();
    _surnameController.dispose();
    _nameController.dispose();
    _middleNameController.dispose();
    _iinController.dispose();
    _birthController.dispose();
    _lengthController.dispose();
    _weightController.dispose();
    _genderController.dispose();
    _addressController.dispose();
    _mailController.dispose();
    _contactController.dispose();
    _familyContactController.dispose();
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyles.backgroundColor,
      appBar: AppBar(
        backgroundColor: ColorStyles.primaryColor,
        title: Text('Добавить пациента',style: GoogleFonts.montserrat(fontSize: 17,
        color: ColorStyles.whiteColor,fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text('Участок',style: GoogleFonts.montserrat(fontSize: 13,fontWeight: FontWeight.w600,color: ColorStyles.blackColor),)
                ],
              ),
              const SizedBox(height: 4),
              AddTextField(controller: _uchastokController,hintText: 'Участок',),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text('Фамилия',style: GoogleFonts.montserrat(fontSize: 13,fontWeight: FontWeight.w600,color: ColorStyles.blackColor),)
                ],
              ),
              const SizedBox(height: 4),
              AddTextField(controller: _uchastokController,hintText: 'Фамилия',),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text('Имя',style: GoogleFonts.montserrat(fontSize: 13,fontWeight: FontWeight.w600,color: ColorStyles.blackColor),)
                ],
              ),
              const SizedBox(height: 4),
              AddTextField(controller: _uchastokController,hintText: 'Имя',),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text('Отчество',style: GoogleFonts.montserrat(fontSize: 13,fontWeight: FontWeight.w600,color: ColorStyles.blackColor),)
                ],
              ),
              const SizedBox(height: 4),
              AddTextField(controller: _uchastokController,hintText: 'Отчество',),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text('ИИН',style: GoogleFonts.montserrat(fontSize: 13,fontWeight: FontWeight.w600,color: ColorStyles.blackColor),)
                ],
              ),
              const SizedBox(height: 4),
              AddTextField(controller: _uchastokController,hintText: 'ИИН',),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text('Дата рождения',style: GoogleFonts.montserrat(fontSize: 13,fontWeight: FontWeight.w600,color: ColorStyles.blackColor),)
                ],
              ),
              const SizedBox(height: 4),
              AddTextField(controller: _uchastokController,hintText: 'Дата рождения',),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text('Рост (см)',style: GoogleFonts.montserrat(fontSize: 13,fontWeight: FontWeight.w600,color: ColorStyles.blackColor),)
                ],
              ),
              const SizedBox(height: 4),
              AddTextField(controller: _uchastokController,hintText: 'Рост (см)',),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text('Вес (кг)',style: GoogleFonts.montserrat(fontSize: 13,fontWeight: FontWeight.w600,color: ColorStyles.blackColor),)
                ],
              ),
              const SizedBox(height: 4),
              AddTextField(controller: _uchastokController,hintText: 'Вес (кг)',),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text('Пол',style: GoogleFonts.montserrat(fontSize: 13,fontWeight: FontWeight.w600,color: ColorStyles.blackColor),)
                ],
              ),
              const SizedBox(height: 4),
              AddTextField(controller: _uchastokController,hintText: 'Пол',),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text('Адрес проживания',style: GoogleFonts.montserrat(fontSize: 13,fontWeight: FontWeight.w600,color: ColorStyles.blackColor),)
                ],
              ),
              const SizedBox(height: 4),
              AddTextField(controller: _uchastokController,hintText: 'Адрес проживания',),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text('Почта',style: GoogleFonts.montserrat(fontSize: 13,fontWeight: FontWeight.w600,color: ColorStyles.blackColor),)
                ],
              ),
              const SizedBox(height: 4),
              AddTextField(controller: _uchastokController,hintText: 'Почта',),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text('Контактный телефон',style: GoogleFonts.montserrat(fontSize: 13,fontWeight: FontWeight.w600,color: ColorStyles.blackColor),)
                ],
              ),
              const SizedBox(height: 4),
              AddTextField(controller: _uchastokController,hintText: 'Контактный телефон',),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text('Контактный телефон родственника',style: GoogleFonts.montserrat(fontSize: 13,fontWeight: FontWeight.w600,color: ColorStyles.blackColor),)
                ],
              ),
              const SizedBox(height: 4),
              AddTextField(controller: _uchastokController,hintText: 'Контактный телефон родственника',),
            ],
          ),
        ),
      ),
    );
  }
}