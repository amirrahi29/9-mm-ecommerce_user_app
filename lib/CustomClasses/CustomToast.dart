import 'dart:ui';
import 'package:get/get.dart';

class CustomToast{

  void snackBarToast(String title, String description, Color textColor, Color backgroundColor){
    Get.snackbar(title, description,colorText: textColor,backgroundColor: backgroundColor);
  }

}