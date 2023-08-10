import 'package:courier_app/src/core/config/routes.dart';
import 'package:courier_app/src/features/features/add_order/add_order_controller.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../components/custom_appbar.dart';
import '../../../components/custom_button.dart';
import '../../../components/custom_divider.dart';
import '../../../components/custom_text.dart';
import '../../../components/custom_textfield.dart';
import '../../../core/constants/assets.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/constants/font_weight.dart';
import '../../../core/constants/palette.dart';
import '../../../core/constants/strings.dart';
import 'add_order3_screen.dart';

class AddOrderTwoScreen extends StatefulWidget {
  const AddOrderTwoScreen({super.key});

  @override
  State<AddOrderTwoScreen> createState() => _AddOrderTwoScreenState();
}

class _AddOrderTwoScreenState extends State<AddOrderTwoScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController doorFlatController = TextEditingController();
  TextEditingController streetAreaController = TextEditingController();
  TextEditingController cityTownController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final AddOrderController addOrderController = Get.put(AddOrderController());

  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        appBar: AppBar(),
        title: strItemDetail,
        containerColor: AppColors.transparent,
        text: '',
        color: AppColors.transparent,
      ),
      body: SafeArea(
        child: Form(
          key: formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: margin_15),
            children: [
              Container(
                width: double.infinity, //// Take full width of the screen
                height: height_70,
                decoration: BoxDecoration(
                  color: AppColors.transparent,
                ),
                child: Stepper(
                  currentStep: _currentStep,
                  type: StepperType.horizontal,
                  steps: [
                    Step(
                      title: Text(''),
                      content: Text(''),
                      isActive: _currentStep >= 0,
                    ),
                    Step(
                      title: Text(''),
                      content: Text(''),
                      isActive: _currentStep >= 1,
                    ),
                    Step(
                      title: Text(''),
                      content: Text(''),
                      isActive: _currentStep >= 2,
                    ),
                    Step(
                      title: Text(''),
                      content: Text(''),
                      isActive: _currentStep >= 3,
                    ),
                  ],
                  elevation: 0,
                  onStepTapped: (index) {
                    setState(() {
                      _currentStep = index;
                    });
                  },
                ),
              ),

              Align(
                alignment: Alignment.topLeft,
                child: CustomText(
                    text: strReceiverDetails, color1: AppColors.black, fontWeight: fontWeight700, fontSize: font_20),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: CustomText(
                    text: strEnterDetBelow, color1: AppColors.greyColor, fontWeight: fontWeight400, fontSize: font_13),
              ),

              CustomDivider(
                height: height_10,
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
                validator: ValidationBuilder().required().build(),
              ), //user text-field

              CustomTextField(
                labelText: strMobNo,
                prefixIcon: const Image(
                  image: AssetImage(ImgAssets.phoneIcon),
                ),
                obscure: false,
                height: 0,
                textInputType: TextInputType.number,
                controller: phoneController,
                validator: ValidationBuilder().required().phone().build(),
              ),

              CustomTextField(
                labelText: strEnterEmail,
                prefixIcon: const Image(
                  image: AssetImage(ImgAssets.emailIcon),
                ),
                obscure: false,
                height: height_15,
                textInputType: TextInputType.text,
                controller: emailController,
                validator: ValidationBuilder().required().email().build(),
              ), //email text-field

              CustomText(
                  text: strDeliveryAddress, color1: AppColors.greyColor, fontWeight: fontWeight400, fontSize: font_13),

              CustomDivider(
                height: height_10,
                isDivider: false,
              ),

              CustomTextField(
                labelText: strDoorFlat,
                prefixIcon: const Image(
                  image: AssetImage(ImgAssets.locationIcon),
                ),
                obscure: false,
                height: height_15,
                textInputType: TextInputType.text,
                controller: doorFlatController,
                validator: ValidationBuilder().required().build(),
              ),

              CustomTextField(
                labelText: strStreetArea,
                obscure: false,
                height: height_15,
                textInputType: TextInputType.text,
                prefixIcon: null,
                controller: streetAreaController,
                validator: ValidationBuilder().required().build(),
              ),
              CustomTextField(
                labelText: strCityTown,
                obscure: false,
                height: height_15,
                textInputType: TextInputType.text,
                prefixIcon: null,
                controller: cityTownController,
                validator: ValidationBuilder().required().build(),
              ),
              CustomTextField(
                labelText: strPincode,
                obscure: false,
                height: height_15,
                textInputType: TextInputType.text,
                prefixIcon: null,
                controller: pincodeController,
                validator: ValidationBuilder().required().build(),
              ),
              CustomDivider(
                height: height_25,
                isDivider: false,
              ),
              Obx(
                () => addOrderController.isLoading.isTrue
                    ? const Center(
                        child: CircularProgressIndicator(
                        color: AppColors.orange,
                      ))
                    : CustomButton(
                        text: strContinue,
                        color: AppColors.white,
                        fontWeight: fontWeight800,
                        font: font_16,
                        onPress: () async {
                          if (formKey.currentState!.validate()) {
                            print('order id  2${addOrderController.orderId}');
                            String orderId = await addOrderController.addReceiverDetails(
                                addOrderController.orderId,
                                nameController.text,
                                phoneController.text,
                                emailController.text,
                                doorFlatController.text,
                                streetAreaController.text,
                                cityTownController.text,
                                pincodeController.text);
                            if (orderId.isNotEmpty) {
                              Get.toNamed(AppRoutes.addOrderThree);
                            }
                          }
                        },
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
