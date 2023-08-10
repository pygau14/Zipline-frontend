import 'package:courier_app/src/features/auth/auth/auth.dart';
import 'package:courier_app/src/features/auth/forgot_password2/forgot_password_2_controller.dart';
import 'package:courier_app/src/features/auth/new_password/new_password_controller.dart';
import 'package:courier_app/src/features/features/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';

import '../../../components/custom_button.dart';
import '../../../components/custom_divider.dart';
import '../../../components/custom_text.dart';
import '../../../components/custom_textfield.dart';
import '../../../core/constants/assets.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/constants/font_weight.dart';
import '../../../core/constants/palette.dart';
import '../../../core/constants/strings.dart';

class NewPasswordScreen extends GetView<AuthController> {
  NewPasswordScreen({super.key});

  final ForgotPassword2Controller forgotPassword2Controller = Get.put(ForgotPassword2Controller());
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
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

              CustomTextField(
                labelText: strEnterPass,
                prefixIcon: const Image(
                  image: AssetImage(ImgAssets.passIcon),
                ),
                obscure: false,
                height: height_15,
                textInputType: TextInputType.text,
                controller: passwordController,
                validator: ValidationBuilder().required().build(),
              ), //email text-field

              CustomTextField(
                labelText: strConfirmPass,
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
                validator: ValidationBuilder()
                    .add((value) {
                      if (passwordController.text != value) {
                        return 'passwords do not match';
                      } else {
                        return null;
                      }
                    })
                    .required()
                    .build(),
              ), // password text-field

              CustomDivider(
                height: height_40,
                isDivider: false,
              ),
              Obx(
                () => forgotPassword2Controller.isLoading.isTrue
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.orange,
                        ),
                      )
                    : CustomButton(
                        text: strSave,
                        color: AppColors.white,
                        fontWeight: fontWeight800,
                        font: font_16,
                        onPress: () async {
                          if (formKey.currentState!.validate()) {
                            await forgotPassword2Controller.setNewPassword(passwordController.text.trim());
                          }
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
