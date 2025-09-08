import 'package:flutter/material.dart';
import 'package:qmed_employee/core/const/color_styles.dart';
import 'package:qmed_employee/features/home/screens/home_screen.dart';
import 'package:qmed_employee/features/profile/screens/profile_screen.dart';

// ignore: must_be_immutable
class BottomNavBar extends StatefulWidget {
  int index;
  BottomNavBar({super.key, required this.index});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final List<Widget> _widgetOptions =  <Widget>[
   HomeScreen(),
    Container(),
    Container(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      widget.index = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyles.whiteColor,
      body: Container(child: _widgetOptions.elementAt(widget.index)),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: ColorStyles.whiteColor,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: ColorStyles.primaryColor,),
        selectedIconTheme: const IconThemeData(color: ColorStyles.primaryColor,),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Главная",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
            label: "Добавить",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: "Статистика",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            label: "Профиль",
          ),
        ],
        currentIndex: widget.index,
        selectedItemColor: ColorStyles.primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     _showAlertDialog(context);
      //   },
      //   backgroundColor:  ColorStyles.primaryColor,
      //   shape: const CircleBorder(),
      //   child: Image.asset(
      //     'assets/images/png/qr.png',
      //     width: 28,
      //     height: 28,
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void _showDevelopmentAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "On Development",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          content: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  "This feature is currently under development.",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: [
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.close,
                      color: Colors.black,
                    ))
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/png/qr.png', width: 140, height: 140,
                  // width: 140,
                  // height: 140,
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }
}
