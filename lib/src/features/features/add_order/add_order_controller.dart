import 'dart:convert';

import 'package:courier_app/src/core/constants/user_constants.dart';
import 'package:courier_app/src/features/auth/auth/preferences_service.dart';
import 'package:courier_app/src/features/features/add_order/order_summary_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/strings.dart';
import 'package:http/http.dart' as http;

class AddOrderController extends GetxController {
  // List<Steps> getStep => [
  // Step(title: 'title', content: Container())
  // ];
  final List<String> itemTypes = ['Beam', 'Documents', 'Force', 'Clear'];
  final List<String> itemCategories = ['Priority', 'Classified'];
  String? selectedValue = strSelectItemType;
  String orderId = '';
  RxString itemDeliveryRequired = ''.obs;
  RxBool isCategoryUpdated = false.obs;

  RxBool isLoading = false.obs;
  final SharedPreferences prefs = PreferencesService.instance;

  RxString imagePath = ''.obs;

  Future<void> getImage() async {
    final ImagePicker _picker = ImagePicker();
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      imagePath.value = image.path.toString();
    }
  }

  Future<String> addSenderDetails(String senderName, String contactNum, String emailAddress, String doorFlatNum,
      String streetAreaName, String cityTown, String pincode) async {
    isLoading.value = true;
    bool isOrderAdded = false;

    final url = Uri.parse('https://courier.hnktrecruitment.in/add-order');
    final body = jsonEncode({
      'user_id': prefs.getInt(UserContants.userId),
      'name': senderName,
      'contact_no': contactNum,
      'email_address': emailAddress,
      'door_flat_no': doorFlatNum,
      'street_area_name': streetAreaName,
      'city_town': cityTown,
      'pincode': pincode,
    });

    try {
      final response = await http.post(
        url,
        body: body,
        headers: {'Content-Type': 'application/json'},
      );

      final data = response.body.toString();
      final jsonData = jsonDecode(data);

      if (response.statusCode == 200) {
        isOrderAdded = true;
        orderId = jsonData['order_id'].toString();
        Fluttertoast.showToast(msg: jsonData['message'], timeInSecForIosWeb: 20);
      } else {
        isOrderAdded = false;
        Fluttertoast.showToast(msg: jsonData['error']);
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: 'Error: ${e.toString()}');
    }
    isLoading.value = false;
    return orderId;
  }

  Future<String> addReceiverDetails(String orderId, String senderName, String contactNum, String emailAddress,
      String doorFlatNum, String streetAreaName, String cityTown, String pincode) async {
    isLoading.value = true;
    bool isReceiverAdded = false;

    final url = Uri.parse('https://courier.hnktrecruitment.in/add-receiver-details');
    final body = jsonEncode({
      'order_id': orderId,
      'name': senderName,
      'contact_no': contactNum,
      'email_address': emailAddress,
      'door_flat_no': doorFlatNum,
      'street_area_name': streetAreaName,
      'city_town': cityTown,
      'pincode': pincode,
    });

    try {
      final response = await http.post(
        url,
        body: body,
        headers: {'Content-Type': 'application/json'},
      );

      final data = response.body.toString();
      final jsonData = jsonDecode(data);

      if (response.statusCode == 200) {
        isReceiverAdded = true;
        orderId = jsonData['order_id'].toString();
        Fluttertoast.showToast(msg: jsonData['message'], timeInSecForIosWeb: 20);
      } else {
        isReceiverAdded = false;
        Fluttertoast.showToast(msg: jsonData['error'], timeInSecForIosWeb: 20);
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: 'Error: ${e.toString()}', timeInSecForIosWeb: 20);
    }
    isLoading.value = false;
    return orderId;
  }

  Future<String> addPackageDetails(String orderId, String itemName, String itemSize, String itemWeight, String itemType,
      String itemCategory, String deliveryRequired, String itemImage, String charges) async {
    isLoading.value = true;
    bool isPackageAdded = false;
    final url = Uri.parse('https://courier.hnktrecruitment.in/add-package-details');

    try {
      var request = http.MultipartRequest('POST', url);
      request.fields['order_id'] = orderId;
      request.fields['item_name'] = itemName;
      request.fields['item_size'] = itemSize;
      request.fields['item_weight'] = itemWeight;
      request.fields['item_type'] = itemType;
      request.fields['item_category'] = itemCategory;
      request.fields['delivery_required'] = deliveryRequired;
      request.fields['charges'] = charges;

      request.files.add(await http.MultipartFile.fromPath('item_image', itemImage));

      final response = await request.send();
      var data = await response.stream.bytesToString();
      var jsonData = jsonDecode(data);

      if (response.statusCode == 200) {
        orderId = jsonData['order_id'];
        isPackageAdded = true;
        Fluttertoast.showToast(msg: jsonData['message']);
      } else {
        Fluttertoast.showToast(msg: jsonData['error']);
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: 'Error: ${e.toString()}');
    }

    isLoading.value = false;
    return orderId;
  }

  Future<OrderSummaryModel?> getOrderSummary(String orderId) async {
    print('order id 4 $orderId');
    // isLoading.value = true;
    OrderSummaryModel? orderSummary;
    final url = Uri.parse('https://courier.hnktrecruitment.in/order-summary/$orderId');
    try {
      final response = await http.get(url);
      final data = response.body.toString();
      final jsonData = jsonDecode(data);
      if (response.statusCode == 200) {
        orderSummary = OrderSummaryModel.fromJson(jsonData);
        print('response ${orderSummary.senderName}');
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: 'An Error Occurred, Check your internet connection and try again!');
    }
    // isLoading.value = false;
    return orderSummary;
  }

  Future<bool> updateSenderSignature(String signatureImagePath) async {
    isLoading.value = true;
    bool isSignatureUpdated = false;

    final url = Uri.parse('https://courier.hnktrecruitment.in/update-sender-signature');

    try {
      var request = http.MultipartRequest('POST', url);
      request.fields['order_id'] = '4';

      request.files.add(await http.MultipartFile.fromPath('sender_signature', signatureImagePath));

      final response = await request.send();
      final data = await response.stream.bytesToString();
      final jsonData = jsonDecode(data);

      if (response.statusCode == 200) {
        isSignatureUpdated = true;
        Fluttertoast.showToast(msg: jsonData['message']);
      } else {
        Fluttertoast.showToast(msg: jsonData['error']);
      }
    } on Exception catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: "Check your internet connection and try again");
    }

    isLoading.value = false;
    return isSignatureUpdated;
  }

// Future<void> updateOrderPriority(String priority) async {
//   print('priotiy' + priority);
//   isLoading.value = true;
//   final url = Uri.parse('https://courier.hnktrecruitment.in/update-order-priority');
//
//   try {
//     final response = await http.post(url,
//         body: jsonEncode({
//           'order_id': 4,
//           'priority': priority,
//         }),
//         headers: {'Content-Type': 'application/json'});
//     final data = response.body.toString();
//     final jsonData = jsonDecode(data);
//
//     if (response.statusCode == 200) {
//       Fluttertoast.showToast(msg: jsonData['message'], timeInSecForIosWeb: 20);
//     } else {
//       Fluttertoast.showToast(msg: jsonData['error'], timeInSecForIosWeb: 20);
//     }
//   } on Exception catch (e) {
//     Fluttertoast.showToast(msg: 'Check your internet connection and try again', timeInSecForIosWeb: 20);
//   }
//   isLoading.value = false;
// }
}
