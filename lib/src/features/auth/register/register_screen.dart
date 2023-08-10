import 'package:courier_app/src/components/custom_radio.dart';
import 'package:courier_app/src/core/config/routes.dart';
import 'package:courier_app/src/features/auth/register/register_controller.dart';
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
import '../auth/auth.dart';

class RegisterScreen extends GetView<AuthController> {
  RegisterScreen({super.key});

  final AuthController authController = Get.put(AuthController());
  final RegisterController registerController = Get.put(RegisterController());
  TextEditingController nameController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passWordController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController idFrontController = TextEditingController();
  TextEditingController idBackController = TextEditingController();
  TextEditingController profilePicController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
                child: CustomText(
                    text: strRegisterNewAc, color1: AppColors.black, fontWeight: fontWeight700, fontSize: font_20),
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
                labelText: strEnterName,
                prefixIcon: const Image(
                  image: AssetImage(ImgAssets.userIcon),
                ),
                obscure: false,
                height: height_15,
                textInputType: TextInputType.text,
                controller: nameController,
                validator: ValidationBuilder().required('Name is Required').build(),
              ), //email text-field
              CustomTextField(
                labelText: strEnterEmail,
                prefixIcon: const Image(
                  image: AssetImage(ImgAssets.emailIcon),
                ),
                obscure: false,
                height: height_15,
                textInputType: TextInputType.text,
                controller: emailAddressController,
                validator: ValidationBuilder().email().required('Email is Required').build(),
              ), //
              CustomTextField(
                  labelText: strEnterCompany,
                  prefixIcon: const Image(
                    image: AssetImage(ImgAssets.companyIcon),
                  ),
                  obscure: false,
                  height: height_15,
                  textInputType: TextInputType.text,
                  controller: companyNameController,
                  validator: ValidationBuilder().required('Company Name is Required').build()), //
              CustomTextField(
                labelText: strMobNo,
                prefixIcon: const Image(
                  image: AssetImage(ImgAssets.phoneIcon),
                ),
                obscure: false,
                height: height_15,
                textInputType: TextInputType.phone,
                controller: phoneController,
                validator: ValidationBuilder()
                    .phone('Enter a valid phone number')
                    .required('Phone Number is required')
                    .build(),
              ), //
              CustomTextField(
                labelText: strEnterPass,
                prefixIcon: const Image(
                  image: AssetImage(ImgAssets.passIcon),
                ),
                height: height_15,
                textInputType: TextInputType.text,
                controller: passWordController,

                obscure:true,
                validator: ValidationBuilder().required('Password is required').build(),
              ), //
              Obx(() =>
                  CustomTextField(
                    labelText: strConfirmPass,
                    prefixIcon: const Image(
                      image: AssetImage(ImgAssets.passIcon),
                    ),
                    suffixIcon: IconButton(
                      icon:Image(image: AssetImage(registerController.isPasswordVisible.value ?ImgAssets.eye : ImgAssets.eyeHide),
                      ),
                      onPressed: () {
                        registerController.togglePasswordVisibility();
                      },
                    ),
                    obscure: registerController.isPasswordVisible.value,
                    height: height_15,
                    textInputType: TextInputType.text,
                    controller: confirmPassController,
                    validator: (value) {
                      if (value == null || value.isEmpty  ) {
                        return 'field is required';
                      }
                      if(value != passWordController.text){
                        return 'Passwords do not match';
                      }
                      else {
                        return null;
                      }
                    },
                  ), //
              ),

              CustomTextField(
                labelText: strEnterAddress,
                prefixIcon: const Image(
                  image: AssetImage(ImgAssets.locationIcon),
                ),
                obscure: false,
                height: height_15,
                textInputType: TextInputType.text,
                controller: addressController,
                validator: ValidationBuilder().required('Address is required').build(),
              ), //

              CustomRadioButton(),

              CustomDivider(
                height: height_15,
              ),

              CustomTextField(
                labelText: strIdFront,
                prefixIcon: const Image(
                  image: AssetImage(ImgAssets.docIcon),
                ),
                obscure: false,
                height: height_15,
                textInputType: TextInputType.text,
                controller: idFrontController,
                readOnly: true,
                validator: ValidationBuilder().required('Field is required').build(),
                onTap: () async {
                  await registerController.getImage();
                  idFrontController.text = registerController.imagePath.value;
                },
                suffixIcon: Obx(() {
                  final imagePath = registerController.imagePath.value;
                  return Visibility(
                    visible: idFrontController.text.isNotEmpty,
                    child: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        idFrontController.text = '';
                      },
                    ),
                  );
                }),
              ), //
              CustomTextField(
                labelText: strIdBack,
                prefixIcon: const Image(
                  image: AssetImage(ImgAssets.docIcon),
                ),
                obscure: false,
                height: height_15,
                textInputType: TextInputType.text,
                controller: idBackController,
                validator: ValidationBuilder().required().build(),
                onTap: () async {
                  await registerController.getImage();
                  idBackController.text = registerController.imagePath.value;
                },
                readOnly: true,
                suffixIcon: Obx(() {
                  final imagePath = registerController.imagePath.value;
                  return Visibility(
                    visible: idBackController.text.isNotEmpty,
                    child: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        idBackController.text = '';
                      },
                    ),
                  );
                }),
              ), //

              CustomTextField(
                labelText: strUploadPhoto,
                prefixIcon: const Image(
                  image: AssetImage(ImgAssets.uploadIcon),
                ),
                obscure: false,
                height: height_15,
                textInputType: TextInputType.text,
                controller: profilePicController,
                readOnly: true,
                validator: ValidationBuilder().required('Field is required').build(),
                onTap: () async {
                  await registerController.getImage();
                  profilePicController.text = registerController.imagePath.value;
                },
                suffixIcon: Obx(() {
                  final imagePath = registerController.imagePath.value;
                  return Visibility(
                    visible: profilePicController.text.isNotEmpty,
                    child: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        profilePicController.text = '';
                      },
                    ),
                  );
                }),
              ), //
              CustomDivider(
                height: height_25,
                isDivider: false,
              ),
              Obx(
                () => authController.isLoading.isTrue
                    ? const Center(child: CircularProgressIndicator())
                    : CustomButton(
                        text: strGetOtp,
                        color: AppColors.white,
                        fontWeight: fontWeight800,
                        font: font_16,
                        onPress: () async {
                          if (formKey.currentState!.validate()) {
                            authController.setUserInformation(
                                name: nameController.text,
                                email: emailAddressController.text,
                                company: companyNameController.text,
                                phone: phoneController.text,
                                passWord: passWordController.text,
                                address: addressController.text,
                                idFront: idFrontController.text,
                                idBack: idBackController.text,
                                profilePhoto: profilePicController.text);
                            if (authController.isEmailVerified.isTrue && authController.isPhoneVerified.isTrue) {
                              await authController.registerUser();
                            } else {
                              await authController.sendPhoneOTP(phoneController.text);
                            }
                          }
                        },
                      ),
              ),

              CustomDivider(
                height: height_50,
                isDivider: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
