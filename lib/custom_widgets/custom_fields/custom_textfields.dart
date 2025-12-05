import 'package:flutter/material.dart';

import '../my_colors/my_colors.dart';


class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final int? maxLength;
  final bool? obsureText;
  final String? Function(String?)? validator;
  final Function? onTap;
  final bool? readOnly;
  final Widget? preFixIcon;
  final Widget? sufFixIcon;
  final TextInputAction? inputAction;
  final String? labelText;
  final int? maxLine;

  const CustomTextField({
    super.key,
    required this.keyboardType,
    required this.controller,
    required this.hintText,
    this.maxLength,
    this.obsureText,
    this.validator,
    this.readOnly,
    this.preFixIcon,
    this.sufFixIcon,
    this.onTap,
    this.labelText,
    this.inputAction,
    this.maxLine,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: MyColors.primaryColor,
      controller: controller,
      keyboardType: keyboardType,
      maxLength: maxLength,
      validator: validator,
      maxLines: maxLine,
      readOnly: readOnly ?? false,
      obscureText: obsureText ?? false,
      textInputAction: inputAction,
      onTap: () {
        if ((readOnly ?? false) && onTap != null) {
          onTap!();
        }
      },
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: MyColors.primaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.black87),
        ),
        border: OutlineInputBorder(),
        prefixIcon: preFixIcon,
        suffixIcon: sufFixIcon,
        hintText: hintText,
        labelText: labelText,
        labelStyle: TextStyle(color: MyColors.blackColor),
        floatingLabelStyle: TextStyle(color: MyColors.primaryColor),
        hintStyle: TextStyle(color: MyColors.blackColor),
      ),
    );
  }
}