import 'package:courier_app/src/components/custom_textfield.dart';
import 'package:courier_app/src/core/config/routes.dart';
import 'package:courier_app/src/core/constants/custom_tiles.dart';
import 'package:courier_app/src/features/auth/forgot_password2/forge_password2.dart';
import 'package:courier_app/src/features/auth/forgot_password/forgot_password_controller.dart';
import 'package:courier_app/src/features/auth/otp_mob/otp_mobile_screen.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';

import '../../../components/custom_button.dart';
import '../../../components/custom_divider.dart';
import '../../../components/custom_text.dart';
import '../../../core/constants/assets.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/constants/font_weight.dart';
import '../../../core/constants/palette.dart';
import '../../../core/constants/strings.dart';
import '../auth/auth.dart';

class ForgotPasswordScreen extends GetView<AuthController> {
  ForgotPasswordScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: margin_15),
            children: [
              CustomDivider(
                height: height_15,
                isDivider: false,
              ),
              Align(
                alignment: Alignment.topLeft,
                child:
                    CustomText(text: strForget, color1: AppColors.black, fontWeight: fontWeight700, fontSize: font_20),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: CustomText(
                    text: strForgotPass, color1: AppColors.greyColor, fontWeight: fontWeight400, fontSize: font_11),
              ),
              CustomDivider(
                height: height_30,
                isDivider: false,
              ),
              Image.asset(ImgAssets.forgotArt, height: height_250),
              CustomDivider(
                height: height_40,
                isDivider: false,
              ),
              CustomTextField(
                labelText: strEnterEmail,
                prefixIcon: const Image(
                  image: AssetImage(ImgAssets.emailIcon),
                ),
                obscure: false,
                height: height_15,
                controller: emailController,
                textInputType: TextInputType.text,
                validator: ValidationBuilder().required().email().build(),
              ), //email text-field

              CustomTextField(
                labelText: 'Enter Phone Number',
                prefixIcon: const Image(
                  image: AssetImage(ImgAssets.passIcon),
                ),
                obscure: false,
                height: 0,
                textInputType: TextInputType.number,
                controller: phoneController,
                validator: ValidationBuilder().required().build(),
              ),
              CustomDivider(
                height: height_60,
                isDivider: false,
              ),
              CustomButton(
                text: strContinue,
                color: AppColors.white,
                fontWeight: fontWeight800,
                font: font_16,
                onPress: () {
                  if (formKey.currentState!.validate()) {
                    Get.toNamed(
                        '${AppRoutes.forgotPass2}?email=${emailController.text}&phone=${phoneController.text.trim()}');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
