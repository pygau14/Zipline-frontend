import 'package:courier_app/src/core/constants/dimensions.dart';
import 'package:courier_app/src/core/constants/font_weight.dart';
import 'package:courier_app/src/core/constants/palette.dart';
import 'package:flutter/material.dart';

import 'custom_divider.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField({
    Key? key,
    required this.labelText,
    required this.prefixIcon,
    this.suffixIcon,
    required this.obscure,
    required this.height,
    required this.textInputType,
    this.controller,
    this.onChanged,
    this.initialValue,
    this.onTap,
    this.validator,
    this.readOnly = false,
    this.showCursor,
  }) : super(key: key);

  final String labelText;
  final Image? prefixIcon;
  final dynamic suffixIcon;
  final double height;
  final TextInputType textInputType;
  final Function(String)? onChanged;
  final Function()? onTap;
  String? Function(String?)? validator;
  final String? initialValue;
  final bool obscure;
  final bool readOnly;
  final bool? showCursor;

  TextEditingController? controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          keyboardType: textInputType,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          cursorColor: AppColors.orange,
          initialValue: initialValue,
          onChanged: onChanged,
          showCursor: showCursor,
          controller: controller,
          obscureText: obscure,
          validator: validator,
          style: TextStyle(color: AppColors.orange, fontSize: font_13, fontWeight: fontWeight400),
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: TextStyle(fontSize: font_14, fontFamily: 'Mukta', fontWeight: fontWeight400),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radius_10),
                borderSide: BorderSide(color: AppColors.greyColor.withOpacity(.3))),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radius_10),
                borderSide: BorderSide(color: AppColors.greyColor.withOpacity(.3))),
          ),
          onTap: onTap,
          readOnly: readOnly,
        ),
        CustomDivider(
          height: height_15,
          isDivider: false,
        ),
      ],
    );
  }
}
