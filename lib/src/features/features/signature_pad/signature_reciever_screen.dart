import 'dart:io';
import 'dart:typed_data';

import 'package:courier_app/src/core/config/routes.dart';
import 'package:courier_app/src/features/features/signature_pad/signature_pad_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'dart:ui' as ui;
import '../../../components/custom_appbar.dart';
import '../../../components/custom_button.dart';
import '../../../components/custom_divider.dart';
import '../../../components/custom_text_button.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/constants/font_weight.dart';
import '../../../core/constants/palette.dart';
import '../../../core/constants/strings.dart';

class SignatureRecieverScreen extends GetView<SignaturePadController> {
  final String orderId;

  SignatureRecieverScreen({super.key, required this.orderId});

  SignaturePadController signatureController = Get.put(SignaturePadController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: CustomAppBar(appBar: AppBar()),
      appBar: CustomAppbar(
        appBar: AppBar(),
        title: strRecieverSign,
        containerColor: AppColors.transparent,
        text: '',
        color: AppColors.transparent,
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: margin_10),
          children: [
            CustomDivider(
              height: height_30,
              isDivider: false,
            ),
            Container(
              height: height_500,
              width: width_340,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(radius_10),
                  border: Border.all(color: AppColors.black, width: 1.2, strokeAlign: BorderSide.strokeAlignOutside)),
              child: SfSignaturePad(
                key: controller.signaturePadKey,
                backgroundColor: Colors.transparent,
                minimumStrokeWidth: width_3,
                maximumStrokeWidth: width_4,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: margin_140),
              child: CustomTextButton(
                  text: strClear,
                  color: AppColors.orange,
                  fontWeight: fontWeight600,
                  font: font_13,
                  onPress: () {
                    controller.signaturePadKey.currentState!.clear();
                  }),
            ),
            CustomDivider(
              height: height_30,
              isDivider: false,
            ),
            CustomButton(
              text: strAddSign,
              color: AppColors.white,
              fontWeight: fontWeight800,
              font: font_16,
              onPress: () async {
                ui.Image image = await controller.signaturePadKey.currentState!.toImage();
                final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
                final Uint8List imageBytes =
                    byteData!.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
                final String path = (await getApplicationSupportDirectory()).path;
                final String fileName = '$path/output.png';

                await File(fileName).writeAsBytes(imageBytes);
                bool isSignatureAdded = await signatureController.updateReceiverSignature(fileName, orderId);
                if (isSignatureAdded) {
                  Get.back();
                  Get.back();
                }
              },
            ),
            CustomDivider(
              height: height_55,
              isDivider: false,
            ),
          ],
        ),
      ),
    );
  }
}
