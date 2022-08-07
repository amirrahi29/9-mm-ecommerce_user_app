import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:user_app/CustomClasses/ALL_COLORS.dart';
import 'package:user_app/CustomClasses/CustomToast.dart';
import 'package:user_app/CustomClasses/SingeltonClass.dart';
import 'package:user_app/view/HomePage.dart';

class AccountViewModel extends GetxController{

  var isLoadingUser = true.obs;
  var name = "".obs;
  var email = "".obs;
  var photo = "".obs;
  var gender = "".obs;
  var dob = "".obs;
  var isLoadingProgressIndicator = false.obs;
  var selectedGender = "male".obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getUserDetails();
  }

  onSelectGender(String gender){
    selectedGender.value = gender;
    SingeltonClass().myLogs(gender);
  }

  getUserDetails() async{
    var userEmail =  await SingeltonClass().getUserEmail();
    if(userEmail != null){
      await FirebaseFirestore.instance.collection("users")
          .doc(userEmail).get()
          .then((value){
        SingeltonClass().myLogs("user details fetched.");
        name.value = value.data()!['name'];
        email.value = value.data()!['email'];
        gender.value = value.data()!['gender'];
        dob.value = value.data()!['dob'];
        photo.value = value.data()!['image'];
      }).catchError((error){
        SingeltonClass().myLogs(error);
      });
    }
  }

  accountEditFormSubmit(BuildContext context, String name, String dob, File imageFile) async{
    isLoadingProgressIndicator.value = true;
    var userEmail =  await SingeltonClass().getUserEmail();
    if(userEmail != null){

      UploadTask uploadTask = FirebaseStorage.instance.ref().child("users/"+userEmail)
      .putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;
      String? uploadedImageUrl = await taskSnapshot.ref.getDownloadURL();
      if(uploadedImageUrl != null){
        await FirebaseFirestore.instance.collection("users")
            .doc(userEmail).update({
          'name':name,
          'gender':selectedGender.value,
          'dob':dob,
          'image':uploadedImageUrl
        }).then((value){
          isLoadingProgressIndicator.value = false;
          CustomToast().snackBarToast("Congrats!",
              "Account updated successfully.", whiteColor, greenColor);
          SingeltonClass().myLogs("Account updated successfully.");
          Get.offAll(HomePage());
        })
            .catchError((error){
          isLoadingProgressIndicator.value = false;
          CustomToast().snackBarToast("Updation failed!",
              error.toString(), whiteColor, redColor);
          SingeltonClass().myLogs(error);
        });
      }
    }else{
      isLoadingProgressIndicator.value = false;
      SingeltonClass().myLogs("E-mail id is null");
    }
  }

}