import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:user_app/CustomClasses/CustomToast.dart';
import 'package:user_app/view_model/SignUpViewModel.dart';
import '../../CustomClasses/ALL_COLORS.dart';
import '../../CustomClasses/ALL_IMAGES.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final signUpViewModel = Get.put(SignUpViewModel());
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  File? imageFile;
  final ImagePicker _picker = ImagePicker();

  chooseImageFromGallery() async{
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    imageFile = File(image!.path);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: greenColor,
            title: Text("Sign Up"),
          ),
            body: Obx(()=>
                LoadingOverlay(
                  isLoading: signUpViewModel.isLoadingProgressIndicator.value,
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
                          children: <Widget>[

                            imageFile == null || imageFile == ""?
                            InkWell(
                              onTap: (){
                                chooseImageFromGallery();
                              },
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: <Widget>[

                                  Container(
                                    height: 120,
                                    width: 120,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        color: greyColor
                                    ),
                                  ),

                                  Positioned(
                                      bottom: 0,right: 16,
                                      child: Icon(Icons.camera_alt_outlined))

                                ],
                              ),
                            ):
                            InkWell(
                              onTap: (){
                                chooseImageFromGallery();
                              },
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: <Widget>[

                                  Container(
                                    height: 120,
                                    width: 120,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: FileImage(imageFile!),
                                          fit: BoxFit.cover
                                        ),
                                        borderRadius: BorderRadius.circular(100),
                                        color: greyColor
                                    ),
                                  ),

                                  Positioned(
                                      bottom: 0,right: 16,
                                      child: Icon(Icons.camera_alt_outlined))

                                ],
                              ),
                            ),

                            SizedBox(height: 32,),

                            TextField(
                              controller: nameController,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8)
                                  ),
                                  hintText: 'Enter your full name',
                                  labelText: 'Name',
                                  prefixIcon: Icon(Icons.person_outline)
                              ),
                            ),

                            SizedBox(height: 8,),

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
                              obscureText: true,
                              keyboardType: TextInputType.visiblePassword,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8)
                                  ),
                                  hintText: 'Enter your password',
                                  labelText: 'Password',
                                  prefixIcon: Icon(Icons.lock)
                              ),
                            ),

                            SizedBox(height: 8,),

                            TextField(
                              controller: dateOfBirthController,
                              keyboardType: TextInputType.datetime,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8)
                                  ),
                                  hintText: 'Date of birth (Eg.09/07/1996)',
                                  labelText: 'D.O.B',
                                  prefixIcon: Icon(Icons.date_range)
                              ),
                            ),

                            SizedBox(height: 16,),

                            Row(
                              children: <Widget>[

                                InkWell(
                                  onTap: (){
                                    signUpViewModel.onSelectGender("male");
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: signUpViewModel.selectedGender.value == "male"?
                                            greenColor:Colors.grey[500],
                                        borderRadius: BorderRadius.circular(8)
                                    ),
                                    child: Text("Male",
                                      style: TextStyle(color: whiteColor,
                                          fontSize: 24),),
                                  ),
                                ),

                                SizedBox(width: 16,),

                                InkWell(
                                  onTap: (){
                                    signUpViewModel.onSelectGender("female");
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: signUpViewModel.selectedGender.value == "female"?
                                        greenColor:Colors.grey[500],
                                        borderRadius: BorderRadius.circular(8)
                                    ),
                                    child: Text("Female",
                                      style: TextStyle(color: whiteColor,
                                          fontSize: 24),),
                                  ),
                                ),

                              ],
                            ),

                            SizedBox(height: 16,),

                            TextButton(
                              onPressed: (){
                                if(nameController.text != "" && emailController.text != "" &&
                                    passwordController.text != "" &&
                                    dateOfBirthController.text != "" &&
                                imageFile != null){
                                  signUpViewModel.signUpFormSubmit(
                                    context,
                                    nameController.text,
                                    emailController.text,
                                    passwordController.text,
                                    dateOfBirthController.text,
                                      imageFile!
                                  );
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
                                child: Text("Sign Up",style: TextStyle(
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
                                  Navigator.pop(context);
                                },
                                child: Text("Already have an account ?",
                                  style: TextStyle(color: greenColor,
                                  fontSize: 20),)
                            )

                          ],
                        ),
                      ),
                    ),
                  ),
                ))
        )
    );
  }
}
