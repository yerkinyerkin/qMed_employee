import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qmed_employee/core/const/color_styles.dart';
import 'package:qmed_employee/features/profile/screens/faq/widgets/faq_item.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  List array = [
    {
      'text':'Как записаться на приём к врачу?',
      'subText':'Выберите нужного специалиста в приложении, укажите удобное время и подтвердите запись.',
    },
    {
      'text':'Как вызвать врача на дом?',
      'subText':'В разделе «Услуги» выберите «Вызов врача на дом», заполните адрес и укажите время визита.',
    },
    {
      'text':'Как получить результаты анализов?',
      'subText':'Результаты будут доступны в разделе «Мои анализы» сразу после обработки лабораторией.',
    },
    {
      'text':'Можно ли продлить рецепт через приложение?',
      'subText':'Да, вы можете отправить запрос на продление рецепта врачу, который ведёт ваше лечение.',
    },
    {
      'text':'Как связаться с врачом онлайн?',
      'subText':'В разделе «Чат с врачом» выберите специалиста и начните консультацию.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyles.backgroundColor,
      appBar: AppBar(
        backgroundColor: ColorStyles.primaryColor,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: ColorStyles.whiteColor,),
        title: Text('Часто задаваемые вопросы',
        style: GoogleFonts.montserrat(fontSize: 16,color: ColorStyles.whiteColor,fontWeight: FontWeight.w500),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ListView.builder(
                itemCount: array.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index){
                return FaqItem(text: array[index]['text'],subText: array[index]['subText'],);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}