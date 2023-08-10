import 'package:courier_app/src/core/constants/assets.dart';
import 'package:courier_app/src/core/constants/dimensions.dart';
import 'package:courier_app/src/core/constants/palette.dart';
import 'package:courier_app/src/features/auth/splash/splash_controller.dart';
import 'package:courier_app/src/features/auth/splash/splash_screen_two.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class SplashOneScreen extends StatefulWidget {
  const SplashOneScreen({super.key});

  @override
  State<SplashOneScreen> createState() => _SplashOneScreenState();
}

class _SplashOneScreenState extends State<SplashOneScreen> {

  @override
  void initState() {
    super.initState();
    _navigateToNextScreen(); // Start the navigation process
  }

  _navigateToNextScreen() async {
    await Future.delayed(Duration(seconds: 2)); // Delay of 2 seconds
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SplashTwoScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.orange,
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: margin_15),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(image: AssetImage(ImgAssets.splashOne)),
            ]),
      ),
    );
  }
}
