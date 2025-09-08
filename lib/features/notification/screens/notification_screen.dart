import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qmed_employee/core/const/color_styles.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List array = [
    {
      'text':'Новый пациент назначен',
      'subText':'Айсулу Аманкосова добавлена в ваш сектор. Проверьте карточку и статусы АГ/ХСН/СД.'
    },
    {
      'text':'Опрос просрочен',
      'subText':'У 3 пациентов нет ответа за последнюю неделю. Отправьте напоминание или свяжитесь.'
    },
    {
      'text':'Приём сегодня',
      'subText':'Запланировано 5 визитов. Первый приём в 09:30. Проверьте расписание.'
    },
    {
      'text':'Высокий риск обнаружен',
      'subText':'У Сапарова Айдара повышен риск по ХСН. Требуется контроль и назначение повторного осмотра.'
    },
    {
      'text':'Обновление системы',
      'subText':'Повышена стабильность и скорость. Если что-то не так — перезапустите приложение.'
    },
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyles.backgroundColor,
      appBar: AppBar(
        backgroundColor: ColorStyles.primaryColor,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: ColorStyles.whiteColor,size: 20),
        title: Text('Уведомление',style: GoogleFonts.montserrat(fontSize: 17,
        color: ColorStyles.whiteColor,fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: array.length,
              itemBuilder: (BuildContext context, int index){
                return Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: ColorStyles.whiteColor,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${array[index]['text']}',style: GoogleFonts.montserrat(fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: ColorStyles.blackColor,),),
                               array[index]['text'] == 'Приём сегодня' || array[index]['text'] == 'Обновление системы'  ? Container(
                                height: 8,
                                width: 8,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ) : SizedBox(),
                            ],
                          ),
                          Text('${array[index]['subText']}',style: GoogleFonts.montserrat(fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: ColorStyles.blackColor,),),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}