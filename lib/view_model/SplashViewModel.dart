import 'dart:async';
import 'package:get/get.dart';
import 'package:user_app/CustomClasses/SingeltonClass.dart';
import 'package:user_app/view/HomePage.dart';
import '../view/AuthPages/SignInScreen.dart';

class SplashViewModel extends GetxController{
  
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    checkUserLoggedInOrNot();
  }

  checkUserLoggedInOrNot() async{
    var check = await SingeltonClass().getUserEmail();
    if(check != null && check != ""){
      Future.delayed(Duration(seconds: 3),(){
        Get.offAll(HomePage());
        SingeltonClass().myLogs("account found, redirected to home page");
      });
    }else{
      Future.delayed(Duration(seconds: 3),(){
        Get.offAll(SignInScreen());
        SingeltonClass().myLogs("account not found, redirected to login page");
      });
    }
  }
  
}