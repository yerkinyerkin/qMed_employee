import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qmed_employee/core/const/color_styles.dart';

class FaqItem extends StatefulWidget {
  final String? text;
  final String? subText;
  const FaqItem({super.key,this.text,this.subText});

  @override
  State<FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<FaqItem> {
  bool isHide = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            GestureDetector(
              onTap: (){
                setState(() {
                  isHide = !isHide;
                });
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ColorStyles.primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 9,
                      child: Text(widget.text ?? '', 
                      style: GoogleFonts.montserrat(fontSize: 14,color: ColorStyles.whiteColor,fontWeight: FontWeight.w500),),
                    ),
                    Expanded(flex: 1,child: isHide == true ? Icon(Icons.keyboard_arrow_up_outlined,color: ColorStyles.whiteColor,)  : Icon(Icons.keyboard_arrow_down_outlined,color: ColorStyles.whiteColor,))
                  ],
                ),
              ),
            ),
            isHide == true 
            ? Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: ColorStyles.whiteColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(widget.subText ?? '', 
              style: GoogleFonts.montserrat(fontSize: 14,color: ColorStyles.primaryColor,fontWeight: FontWeight.w500),),
            ) 
            : SizedBox(),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}