import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_app/CustomClasses/ALL_COLORS.dart';
import 'package:user_app/CustomClasses/CustomToast.dart';
import 'package:user_app/view/AuthPages/SignInScreen.dart';
import '../view/HomePage.dart';

class SingeltonClass{

  saveEmailAuthAndNavigate(String email) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("email", email);
    Get.offAll(HomePage());
  }

  getUserEmail() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("email");
  }

  logoutUser() async{
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("email");
    CustomToast().snackBarToast("You have logged out successfully.",
        "Please come again soon!", whiteColor, greenColor);
    Get.offAll(SignInScreen());
  }

  myLogs(String myLog){
    print("Log detail: $myLog");
  }

}