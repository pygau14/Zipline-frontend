import 'dart:convert';

import 'package:courier_app/src/core/constants/user_constants.dart';
import 'package:courier_app/src/features/auth/auth/preferences_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class RegisterController extends GetxController {
  RxString imagePath = ''.obs;

  Future getImage() async {
    final ImagePicker _picker = ImagePicker();
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      imagePath.value = image.path.toString();
    }
  }

  var isPasswordVisible = true.obs;
  var password = ''.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.toggle();
  }

  void setPassword(String value) {
    password.value = value;
  }


}
