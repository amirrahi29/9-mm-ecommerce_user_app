import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_app/view_model/SplashViewModel.dart';
import '../CustomClasses/ALL_IMAGES.dart';
import 'AuthPages/SignInScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  final splashScreenViewModel = Get.put(SplashViewModel());
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Center(
            child: Container(
              width: MediaQuery.of(context).size.height/3,
                child: Image.asset(greenLogo)
            ),
          )
        )
    );
  }
}
