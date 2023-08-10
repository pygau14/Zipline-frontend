import 'package:courier_app/src/components/custom_button.dart';
import 'package:courier_app/src/components/custom_divider.dart';
import 'package:courier_app/src/components/custom_text.dart';
import 'package:courier_app/src/components/custom_text_button.dart';
import 'package:courier_app/src/components/custom_textfield.dart';
import 'package:courier_app/src/core/constants/assets.dart';
import 'package:courier_app/src/core/constants/dimensions.dart';
import 'package:courier_app/src/core/constants/font_weight.dart';
import 'package:courier_app/src/core/constants/palette.dart';
import 'package:courier_app/src/core/constants/strings.dart';
import 'package:courier_app/src/features/auth/auth/auth.dart';
import 'package:courier_app/src/features/auth/forgot_password/forgot_password_screen.dart';

import 'package:courier_app/src/features/auth/otp_mob/otp_mobile_screen.dart';
import 'package:courier_app/src/features/auth/register/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';

class LoginScreen extends GetView<AuthController> {
  LoginScreen({super.key});

  final AuthController authController = Get.put(AuthController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
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
                    CustomText(text: strLetName, color1: AppColors.black, fontWeight: fontWeight700, fontSize: font_20),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: CustomText(
                    text: strInfoBelow, color1: AppColors.greyColor, fontWeight: fontWeight400, fontSize: font_13),
              ),
              CustomDivider(
                height: height_30,
                isDivider: false,
              ),
              Image.asset(ImgAssets.logIn, height: height_250),
              CustomDivider(
                height: height_30,
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
                labelText: strEnterPass,
                prefixIcon: const Image(
                  image: AssetImage(ImgAssets.passIcon),
                ),
                suffixIcon: const Icon(
                  Icons.remove_red_eye_outlined,
                  color: AppColors.greyColor,
                ),
                obscure: true,
                height: 0,
                textInputType: TextInputType.text,
                controller: passwordController,
                validator: ValidationBuilder().required().build(),
              ), // password text-field
              Align(
                alignment: Alignment.topRight,
                child: CustomTextButton(
                  text: strForget,
                  color: AppColors.orange,
                  fontWeight: fontWeight400,
                  font: font_14,
                  onPress: () {
                    Get.to(ForgotPasswordScreen());
                  },
                ),
              ),
              CustomDivider(
                height: height_20,
                isDivider: false,
              ),
              Obx(
                () => authController.isLoading.isTrue
                    ? const Center(child: CircularProgressIndicator())
                    : CustomButton(
                        text: strLogin,
                        color: AppColors.white,
                        fontWeight: fontWeight800,
                        font: font_16,
                        onPress: () async {
                          if (formKey.currentState!.validate()) {
                            await authController.loginUser(emailController.text, passwordController.text);
                          }
                        },
                      ),
              ),

              CustomDivider(
                height: height_20,
                isDivider: false,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: strNotOurMember,
                    color1: AppColors.black,
                    fontWeight: fontWeight500,
                    fontSize: font_13,
                  ),
                  CustomTextButton(
                    text: strRegisterNow,
                    color: AppColors.orange,
                    fontWeight: fontWeight600,
                    font: font_13,
                    onPress: () {
                      Get.to(RegisterScreen());
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}






// toList(),
// onChanged: (value) {
// setState(() {
// selectedValue = value;
// });
// onChanged!(value);
// },
// valueTransformer: (value) => value?.toString(),
// decoration: InputDecoration(
// labelText: selectedValue == null ? 'Select an option' : '',
// ),