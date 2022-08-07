import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_app/CustomClasses/ALL_COLORS.dart';
import 'package:user_app/CustomClasses/CustomToast.dart';
import 'package:user_app/CustomClasses/SingeltonClass.dart';
import 'package:user_app/model/UserModel.dart';
import 'package:user_app/view/HomePage.dart';

class SignUpViewModel extends GetxController{

  final _auth = FirebaseAuth.instance;
  var selectedGender = "male".obs;
  var isLoadingProgressIndicator = false.obs;
  var userRef = FirebaseFirestore.instance.collection("users");

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  onSelectGender(String gender){
    selectedGender.value = gender;
    SingeltonClass().myLogs(gender);
  }

  signUpFormSubmit(BuildContext context, String name, String email,
      String password, String dob, File imageFile) async {

    //show progress indicator
    isLoadingProgressIndicator.value = true;

    //check user already exists or not
    var userData = await FirebaseFirestore.instance.collection("users").doc(email).get();
    //userData.data()!['email'] != email

    if(!userData.exists){
      SingeltonClass().myLogs("user exist");
      //image upload
      Reference reference = FirebaseStorage.instance.ref().child("users/"+email);
      UploadTask uploadTask = reference.putFile(imageFile);
      TaskSnapshot taskSnapshot  = await uploadTask;
      String? uploadedImageUrl = await taskSnapshot.ref.getDownloadURL();

      if(uploadedImageUrl != null || uploadedImageUrl != ""){
        SingeltonClass().myLogs("profile photo uploaded successfully");
        // create account
        _auth.createUserWithEmailAndPassword(email: email, password: password)
            .then((value){
          UserModel userModel = UserModel(
            name: name,
            email: email,
            password: password,
            dob: dob,
            gender: selectedGender.value,
            image: uploadedImageUrl,
            accountCreated: DateTime.now().toString(),
          );

          userRef.doc(email).set(userModel.toMap())
              .then((value) {
            //navigate to home page
            SingeltonClass().saveEmailAuthAndNavigate(email);
            CustomToast().snackBarToast("Account created!",
                "Congrats! you have created your account successfully",
                whiteColor, greenColor);
            isLoadingProgressIndicator.value = false;
            SingeltonClass().myLogs("account created");
          }).catchError((error){
            CustomToast().snackBarToast("Account creation failed",
                error.toString(),
                whiteColor, redColor);
            isLoadingProgressIndicator.value = false;
            SingeltonClass().myLogs(error);
          });
        }).catchError((error){
          CustomToast().snackBarToast("Account creation failed",
              error.toString(),
              whiteColor, redColor);
          isLoadingProgressIndicator.value = false;
          SingeltonClass().myLogs(error);
        });
      }
    }
    else{
      isLoadingProgressIndicator.value = false;
      CustomToast().snackBarToast("This email is already exists!",
          "Please login to continue",
          whiteColor, redColor);
      SingeltonClass().myLogs("This email is already exists!, Please login to continue");
      Navigator.pop(context);
    }
  }

}