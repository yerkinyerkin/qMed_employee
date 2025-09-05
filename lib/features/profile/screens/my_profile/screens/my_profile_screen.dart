import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qmed_employee/core/const/color_styles.dart';
import 'package:qmed_employee/features/profile/logic/data/models/profile_model.dart';

class MyProfileScreen extends StatefulWidget {
  final ProfileModel? response;
  const MyProfileScreen({super.key,this.response});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyles.backgroundColor,
      appBar: AppBar(
        backgroundColor: ColorStyles.primaryColor,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: ColorStyles.whiteColor,),
        title: Text('Личные данные',style: GoogleFonts.montserrat(fontSize: 17,color: ColorStyles.whiteColor,fontWeight: FontWeight.w500),),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: ColorStyles.whiteColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text('ФИО : ',
                        style: GoogleFonts.montserrat(fontSize: 13,color: ColorStyles.blackColor,fontWeight: FontWeight.w500),),
                        Text('${widget.response?.firstName} ${widget.response?.lastName} ${widget.response?.middleName}',
                        style: GoogleFonts.montserrat(fontSize: 12,color: ColorStyles.blackColor,fontWeight: FontWeight.w500),),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text('Дата рождения : ',
                        style: GoogleFonts.montserrat(fontSize: 13,color: ColorStyles.blackColor,fontWeight: FontWeight.w500),),
                        Text('${widget.response?.birthDate == '' ? 'Не указано' : widget.response?.birthDate} ',
                        style: GoogleFonts.montserrat(fontSize: 12,color: ColorStyles.blackColor,fontWeight: FontWeight.w500),),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text('Email : ',
                        style: GoogleFonts.montserrat(fontSize: 13,color: ColorStyles.blackColor,fontWeight: FontWeight.w500),),
                        Text('${widget.response?.mail == '' ? 'Не указано' : widget.response?.mail} ',
                        style: GoogleFonts.montserrat(fontSize: 12,color: ColorStyles.blackColor,fontWeight: FontWeight.w500),),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text('Адрес : ',
                        style: GoogleFonts.montserrat(fontSize: 13,color: ColorStyles.blackColor,fontWeight: FontWeight.w500),),
                        Text('${widget.response?.address == '' ? 'Не указано' : widget.response?.address} ',
                        style: GoogleFonts.montserrat(fontSize: 12,color: ColorStyles.blackColor,fontWeight: FontWeight.w500),),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text('Номер телефона : ',
                        style: GoogleFonts.montserrat(fontSize: 13,color: ColorStyles.blackColor,fontWeight: FontWeight.w500),),
                        Text('${widget.response?.phoneNumber == '' ? 'Не указано' : widget.response?.phoneNumber} ',
                        style: GoogleFonts.montserrat(fontSize: 12,color: ColorStyles.blackColor,fontWeight: FontWeight.w500),),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text('Пол : ',
                        style: GoogleFonts.montserrat(fontSize: 13,color: ColorStyles.blackColor,fontWeight: FontWeight.w500),),
                        Text('${widget.response?.gender == '' ? 'Не указано' : widget.response?.gender} ',
                        style: GoogleFonts.montserrat(fontSize: 12,color: ColorStyles.blackColor,fontWeight: FontWeight.w500),),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}