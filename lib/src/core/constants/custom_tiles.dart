import 'package:courier_app/src/core/constants/palette.dart';
import 'package:courier_app/src/core/constants/strings.dart';
import 'package:flutter/material.dart';

import '../../components/custom_text.dart';
import 'assets.dart';
import 'dimensions.dart';
import 'font_weight.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({Key?key,
    required this.colorBackCircle,
    required this.border,
      required this.icon,
    required this.title,
    required this.subtitle,
     this.image,
  }): super(key:key);

  final Color colorBackCircle;
  final Color border;
  final String icon;
  final String title;
  final String subtitle;
  final AssetImage? image;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius_15),
          borderSide: BorderSide(color: border)
      ),
      leading: CircleAvatar(
        foregroundImage: image,
        backgroundColor: colorBackCircle,
        radius: radius_20,
        child: Image(image: AssetImage(icon), width: width_20),
      ),
      title: CustomText(
          text: title,
          color1: AppColors.greyColor,
          fontWeight: fontWeight400,
          fontSize: font_13),
      subtitle: CustomText(
          text: subtitle,
          color1: AppColors.black,
          fontWeight: fontWeight600,
          fontSize: font_16),
    );
  }
}
