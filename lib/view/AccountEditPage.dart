import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:user_app/CustomClasses/ALL_COLORS.dart';
import 'package:user_app/view_model/AccountViewModel.dart';

import '../CustomClasses/CustomToast.dart';

class AccountEditPage extends StatefulWidget {
  const AccountEditPage({Key? key}) : super(key: key);

  @override
  _AccountEditPageState createState() => _AccountEditPageState();
}

class _AccountEditPageState extends State<AccountEditPage> {

  final nameController = TextEditingController();
  final dateOfBirthController = TextEditingController();

  File? imageFile;
  final ImagePicker _picker = ImagePicker();
  final accountEditViewModel = Get.put(AccountViewModel());

  chooseImageFromGallery() async{
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    imageFile = File(image!.path);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = accountEditViewModel.name.value;
    dateOfBirthController.text = accountEditViewModel.dob.value;
   accountEditViewModel.selectedGender.value = accountEditViewModel.gender.value;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: greenColor,
            title: Text("Edit account"),
          ),
          body:  Obx(()=>
              LoadingOverlay(
                isLoading: accountEditViewModel.isLoadingProgressIndicator.value,
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
                                    image: DecorationImage(
                                        image: NetworkImage(accountEditViewModel.photo.value),
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
                        ):
                        InkWell(
                          onTap: (){
                            chooseImageFromGallery();
                          },
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: <Widget>[

                              Container(
                                height:100,
                                width: 100,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: CachedNetworkImage(
                                    imageUrl: accountEditViewModel.photo.value,
                                    placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator(
                                          color: greenColor,
                                        )
                                    ),
                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                    fit: BoxFit.cover,
                                  ),
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
                                accountEditViewModel.onSelectGender("male");
                              },
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: accountEditViewModel.selectedGender.value == "male"?
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
                                accountEditViewModel.onSelectGender("female");
                              },
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: accountEditViewModel.selectedGender.value == "female"?
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
                            if(nameController.text != "" &&
                                dateOfBirthController.text != "" &&
                                imageFile != null){
                              accountEditViewModel.accountEditFormSubmit(
                                  context,
                                  nameController.text,
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
                            child: Text("Update",style: TextStyle(
                                fontSize: 20,color: whiteColor
                            ),),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ))
        )
    );
  }
}
