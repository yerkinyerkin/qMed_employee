import 'package:flutter/material.dart';

class VisitsScreen extends StatelessWidget {
  const VisitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: Text('Визиты',style:TextStyle(color:Colors.white)),
  leading: IconButton(
    icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
    onPressed: () {
      Navigator.pop(context);
    },
  ),
  backgroundColor: Color(0xFF1C6BA4),
),
      body: Column(
        children:[
           Padding(
  padding: const EdgeInsets.only(left:10), 
  child: Text(
    'Нурсат Бакыт',
    style: TextStyle(
      fontSize: 18,
      fontFamily:'Montserrat',
      fontWeight: FontWeight.bold,
    ),
  ),
),
Padding(
  padding: const EdgeInsets.only(left:10), 
  child: Text(
    '070101550192',
    style: TextStyle(
      fontSize: 18,
      fontFamily:'Montserrat',
      fontWeight: FontWeight.w400,
    ),
  ),
),
        ]
      )
    );
  }
}

