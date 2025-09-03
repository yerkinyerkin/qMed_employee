import 'package:flutter/material.dart';
import 'package:qmed_employee/core/const/color_styles.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color? color;
  final Color? colorText;
  final bool disabled;
  final TextAlign? textAlign;
  final bool? loading;
  const CustomButton(
      {Key? key,
      required this.text,
      required this.onTap,
      this.color,
      this.colorText,
      this.disabled = false,
      this.textAlign,
      this.loading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: disabled ? () {} : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          minimumSize: Size(double.infinity, 38),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: ColorStyles.primaryColor, // your border color
              width: 1,
            ),
          ),
        ),
        child: loading!
            ? CircularProgressIndicator.adaptive()
            : Text(
          text,
          textAlign: textAlign,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: colorText,
          ),
        ),
      );

  }
}
