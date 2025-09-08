import 'package:flutter/material.dart';

class AddTextField extends StatelessWidget {
  const AddTextField({
    super.key,
    this.controller,
    this.hintText,
    this.prefix,
    this.suffix,
    this.fillColor = const Color(0xFFFFFFFF),
    this.height = 38,
    this.borderRadius = 10,
    this.onChanged,
    this.onTap,
    this.focusNode,
    this.textStyle,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.cursorColor,
    this.autofocus = false,
    this.enabled = true,
  });

  final TextEditingController? controller;
  final String? hintText;
  final Widget? prefix;
  final Widget? suffix;

  final Color fillColor;
  final double height;
  final double borderRadius;

  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final TextStyle? textStyle;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final Color? cursorColor;
  final bool autofocus;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius);

    return SizedBox(
      height: height,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        obscureText: obscureText,
        autofocus: autofocus,
        enabled: enabled,
        style: textStyle,
        onChanged: onChanged,
        onTap: onTap,
        cursorColor: cursorColor ?? Colors.grey,
        textAlignVertical: TextAlignVertical.center, 
        decoration: InputDecoration(
          
          isCollapsed: true,                           
          filled: true,
          fillColor: fillColor,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0xFFA2A2A2),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 4,vertical: 8),

          prefixIcon: prefix,
          prefixIconConstraints: BoxConstraints(
            minWidth: 40,
            minHeight: height,
          ),
          suffixIcon: suffix,
          suffixIconConstraints: BoxConstraints(
            minWidth: 40,
            minHeight: height,
          ),

          border: OutlineInputBorder(
            borderRadius: radius,
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: radius,
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: radius,
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
