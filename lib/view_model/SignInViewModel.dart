import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../CustomClasses/ALL_COLORS.dart';
import '../CustomClasses/CustomToast.dart';
import '../CustomClasses/SingeltonClass.dart';

class SignInViewModel extends GetxController{

  var isSignInLoader = false.obs;
  final _auth = FirebaseAuth.instance;

  signInFormSubmit(String email, String password) async {
    isSignInLoader.value = true;
    _auth.signInWithEmailAndPassword(email: email, password: password)
        .then((value){
          SingeltonClass().saveEmailAuthAndNavigate(email);
          CustomToast().snackBarToast("Welcome back!",
              "You have logged in successfully",
              whiteColor, greenColor);
          isSignInLoader.value = false;
          SingeltonClass().myLogs("account found");
      })
    .catchError((error){
      SingeltonClass().myLogs(error);
      CustomToast().snackBarToast("Oops!, Something went wrong",
          error.toString(),
          whiteColor, redColor);
      isSignInLoader.value = false;
    });
  }

}