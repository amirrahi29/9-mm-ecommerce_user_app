import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:user_app/CustomClasses/CustomToast.dart';
import 'package:user_app/view/AuthPages/SignUpScreen.dart';
import 'package:user_app/view/HomePage.dart';
import 'package:user_app/view_model/SignInViewModel.dart';
import '../../CustomClasses/ALL_COLORS.dart';
import '../../CustomClasses/ALL_IMAGES.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  final signInViewModel = Get.put(SignInViewModel());
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Obx(()=>
              LoadingOverlay(
                isLoading: signInViewModel.isSignInLoader.value,
                child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(backgroundImage),
                      fit: BoxFit.cover
                  )
            ),
            child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[

                      Container(
                          height: 150,
                          width: 200,
                          child: Image.asset(whiteLogo)),

                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)
                            ),
                            hintText: 'Enter your email id',
                            labelText: 'E-mail id',
                            prefixIcon: Icon(Icons.email_outlined)
                        ),
                      ),

                      SizedBox(height: 8,),

                      TextField(
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)
                            ),
                            hintText: 'Enter your password',
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock)
                        ),
                      ),

                      SizedBox(height: 16,),

                      TextButton(
                        onPressed: (){
                          if(emailController.text != ""
                              && passwordController.text != ""){
                            signInViewModel.signInFormSubmit(emailController.text,
                            passwordController.text);
                          }
                          else{
                            CustomToast().snackBarToast("All fields are required!",
                                "Please fill all the fields and try again!",
                                whiteColor, redColor);
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: greenColor,
                          ),
                          child: Text("Sign In",style: TextStyle(
                              fontSize: 20,color: whiteColor
                          ),),
                        ),
                      ),

                      SizedBox(height: 16,),

                      Container(
                        alignment: Alignment.center,
                        child: Text("OR",
                          style: TextStyle(fontSize: 20,
                              fontWeight: FontWeight.bold),),
                      ),

                      SizedBox(height: 16,),

                      TextButton(
                          onPressed: (){
                            Get.to(SignUpScreen());
                          },
                          child: Text("Don't have an account ?",
                            style: TextStyle(color: greenColor,
                                fontSize: 20),)
                      )

                    ],
                  ),
                ),
            ),
          ),
              )
          )
        )
    );
  }
}
