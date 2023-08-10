import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:http/http.dart' as http;

class SignaturePadController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isReceiverSignatureAdded = false.obs;
  GlobalKey<SfSignaturePadState> signaturePadKey = GlobalKey<SfSignaturePadState>();

  Future<bool> updateReceiverSignature(String signatureImagePath, String orderId) async {
    isReceiverSignatureAdded.value = false;
    bool isSignatureUpdated = false;
    isLoading.value = true;

    final url = Uri.parse('https://courier.hnktrecruitment.in/update-receiver-signature');

    try {
      var request = http.MultipartRequest('POST', url);
      request.fields['order_id'] = orderId;

      request.files.add(await http.MultipartFile.fromPath('receiver_signature', signatureImagePath));

      final response = await request.send();
      final data = await response.stream.bytesToString();
      final jsonData = jsonDecode(data);

      if (response.statusCode == 200) {
        isSignatureUpdated = true;
        isReceiverSignatureAdded.value = true;
        Fluttertoast.showToast(msg: jsonData['message']);
      } else {
        Fluttertoast.showToast(msg: jsonData['error']);
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: "Check your internet connection and try again");
    }

    isLoading.value = false;
    return isSignatureUpdated;
  }
}
