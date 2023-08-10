import 'dart:async';
import 'dart:convert';

import 'package:courier_app/src/core/config/routes.dart';
import 'package:courier_app/src/core/constants/user_constants.dart';
import 'package:courier_app/src/features/auth/auth/preferences_service.dart';
import 'package:email_otp/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ForgotPassword2Controller extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final EmailOTP emailAuth2 = EmailOTP();

  RxString verificationId = ''.obs;
  RxBool isLoading = false.obs;
  RxBool isPhoneCodeSent = false.obs;
  RxBool isPhoneVerified = false.obs;
  RxBool isEmailCodeSent = false.obs;
  RxBool isEmailVerified = false.obs;
  RxBool isTimerRunning = false.obs;
  RxInt otpResendTimer = 0.obs;
  int? resendToken;

  String userPhone = '';
  String userEmail = '';

  Future<void> setUserPhoneAndEmail(String phone, String email) async {
    isLoading.value = true;
    userPhone = phone;
    userEmail = email;
    await prefs.setString(UserContants.userPhone, userPhone);
    await prefs.setString(UserContants.userEmail, userEmail);
    isLoading.value = false;
  }

  SharedPreferences prefs = PreferencesService.instance;

  Future<void> setNewPassword(String password) async {
    isLoading.value = true;
    final url = Uri.parse('https://courier.hnktrecruitment.in/forgot-password');

    try {
      final response = await http.post(url,
          body: jsonEncode({
            // 'email': prefs.getString(UserContants.userEmail),
            // 'mobile_number': prefs.getString(UserContants.userPhone),
            'email': 'user223@gmail.com',
            'mobile_number': '1234567891',
            'password': password,
            'confirm_password': password,
          }),
          headers: {'Content-Type': 'application/json'});
      var data = response.body.toString();
      var jsonData = jsonDecode(data);
      if (response.statusCode == 200) {
        int userId = jsonData[UserContants.userId];
        await prefs.setInt(UserContants.userId, userId);
        Fluttertoast.showToast(msg: jsonData['message'], timeInSecForIosWeb: 20);
        Get.offAllNamed(AppRoutes.login);
      } else {
        Fluttertoast.showToast(msg: jsonData['error'], timeInSecForIosWeb: 20);
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: e.toString(), timeInSecForIosWeb: 20);
    }
    isLoading.value = false;
  }

  void startOtpResendTimer() {
    const int resendDelaySeconds = 60;
    otpResendTimer.value = resendDelaySeconds;
    isTimerRunning.value = true; // Timer starts, set the flag to true
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (otpResendTimer.value == 0) {
        timer.cancel();
        isTimerRunning.value = false; // Timer stops, set the flag to false
      } else {
        otpResendTimer.value--;
      }
    });
  }

  Future<void> setEmailOTPConfig(String email) async {
    isLoading.value = true;
    try {
      emailAuth2.setConfig(
          appEmail: "ziplinez53@gmail.com",
          appName: "ziplinez",
          userEmail: email,
          otpLength: 6,
          otpType: OTPType.digitsOnly);

      if (await emailAuth2.sendOTP() == true) {
        isEmailCodeSent.value = true;
        Fluttertoast.showToast(msg: "email OTP sent successfully", timeInSecForIosWeb: 10);
        Get.offNamed(AppRoutes.forgotOtpEmail);
      } else {
        Fluttertoast.showToast(msg: "Email OTP Failed to send", timeInSecForIosWeb: 10);
      }
    } on Exception catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Cant send email otp", timeInSecForIosWeb: 10);
    }
    isLoading.value = false;
  }

  Future<void> verifyEmailOTP2(String otp) async {
    isLoading.value = true;
    try {
      if (await emailAuth2.verifyOTP(otp: otp)) {
        isEmailVerified.value = true;
        Fluttertoast.showToast(msg: "Email OTP verified successfully", timeInSecForIosWeb: 10);
        Get.offNamed(AppRoutes.newPass);
      } else {
        Fluttertoast.showToast(msg: "Can't verify email OTP", timeInSecForIosWeb: 10);
      }
    } on Exception catch (e) {
      isLoading.value = false;
      print('double u');
      Fluttertoast.showToast(msg: "Cant verify email otp");
    }
    isLoading.value = false;
  }

  Future<void> sendPhoneOTP(String phoneNumber) async {
    isLoading.value = true;
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: _verificationCompleted,
        verificationFailed: _verificationFailed,
        codeSent: _codeSent,
        codeAutoRetrievalTimeout: _codeAutoRetrievalTimeout,
      );
      startOtpResendTimer();
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message.toString(), timeInSecForIosWeb: 30);
    }
  }

  Future<void> resendPhoneOTP(String phoneNumber) async {
    if (resendToken != null) {
      try {
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          timeout: const Duration(seconds: 60),
          verificationCompleted: _verificationCompleted,
          verificationFailed: _verificationFailed,
          codeSent: _codeSent,
          codeAutoRetrievalTimeout: _codeAutoRetrievalTimeout,
          forceResendingToken: resendToken,
        );
        startOtpResendTimer();
        Fluttertoast.showToast(msg: "Phone OTP resent successfully", timeInSecForIosWeb: 10);
      } catch (e) {
        print("Resending OTP Failed: $e");
      }
    } else {
      Fluttertoast.showToast(msg: "Resend token not available.", timeInSecForIosWeb: 10);
    }
  }

  Future<void> verifyPhoneOTP(String otp) async {
    isLoading.value = true;
    try {
      AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: otp,
      );
      await _signInWithCredential(credential);
    } catch (e) {
      isLoading.value = false;
      Fluttertoast.showToast(msg: "Phone OTP verification failed", timeInSecForIosWeb: 10);
      print("Verification Failed: $e");
    }
  }

  void _codeAutoRetrievalTimeout(String verificationId) {
    isLoading.value = false;
    this.verificationId.value = verificationId;
    // isPhoneCodeSent.value = true;
  }

  void _verificationCompleted(PhoneAuthCredential credential) async {
    isPhoneCodeSent.value = true;
    await _signInWithCredential(credential);
    print('verification complete called ${isPhoneCodeSent.value}');
  }

  void _verificationFailed(FirebaseAuthException e) {
    isLoading.value = false;
    isPhoneCodeSent.value = false;
    print("Verification Failed: ${e.message}");
  }

  void _codeSent(String verificationId, int? resendToken) {
    isLoading.value = false;
    this.verificationId.value = verificationId;
    isPhoneCodeSent.value = true;
    this.resendToken = resendToken; // Store the resendToken
    Fluttertoast.showToast(msg: "Phone OTP sent successfully", timeInSecForIosWeb: 10);
    Get.toNamed('${AppRoutes.forgotOtpMob}?phone=$userPhone&route=forgot');
    print('code sent called $userPhone');
  }

  Future<void> _signInWithCredential(AuthCredential credential) async {
    try {
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      isLoading.value = false;
      print("User Verified: ${userCredential.user?.uid}");

      if (userCredential.user?.uid != null) {
        Fluttertoast.showToast(msg: "Phone OTP verified successfully", timeInSecForIosWeb: 10);
        isPhoneVerified.value = true;
        startOtpResendTimer();
        Get.toNamed('${AppRoutes.forgotOtpEmail}?email=$userEmail&route=forgot');
        setEmailOTPConfig(userEmail);
      }
    } catch (e) {
      isLoading.value = false;
      print("Sign In Failed: $e");
    }
  }
}
