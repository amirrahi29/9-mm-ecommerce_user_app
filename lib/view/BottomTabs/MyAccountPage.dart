import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_app/view/AccountEditPage.dart';
import 'package:user_app/view/OrdersPage.dart';
import 'package:user_app/view_model/AccountViewModel.dart';
import '../../CustomClasses/ALL_COLORS.dart';
import '../../CustomClasses/ALL_IMAGES.dart';
import '../../view_model/MedicineViewModel.dart';
import '../Drawer/LeftDrawer.dart';

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({Key? key}) : super(key: key);

  @override
  _MyAccountPageState createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {

  final medicinesViewModel = Get.put(MedicineViewModel());
  final myAccountModel = Get.put(AccountViewModel());
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myAccountModel.getUserDetails();
    medicinesViewModel.getAllMedicinesOrders();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            key: _key,
            appBar: AppBar(
                backgroundColor: whiteColor,
                automaticallyImplyLeading: false,
                title: Obx(()=>Row(
                  children: <Widget>[

                    InkWell(
                      onTap: (){
                        _key.currentState!.openDrawer();
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: greenColor
                        ),
                        child: Icon(Icons.filter_list_rounded,
                          size: 24,color: whiteColor,),
                      ),
                    ),

                    Expanded(
                      child: Container(
                        height: 70,
                        alignment: Alignment.center,
                        child: Image.asset(greenLogo),
                      ),
                    ),

                    Badge(
                      badgeContent: Text(medicinesViewModel.cartCount.toString(),
                        style: TextStyle(color: whiteColor),),
                      child: Icon(Icons.shopping_bag_outlined,
                        size: 24,color: greenColor,),
                    )

                  ],
                ),)
            ),
            drawer: LeftDrawer(),
            body: Obx(()=>SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(left: 8,right: 8,top: 100),
                child: Column(
                  children: <Widget>[

                    Stack(
                      clipBehavior: Clip.none,
                      children: <Widget>[

                        Card(
                          elevation: 10,
                          child: Container(
                            color: greyColor,
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.only(left: 8,right: 8,top: 130),
                            child: Row(
                              children: <Widget>[

                                Expanded(
                                  flex: 1,
                                  child: InkWell(
                                    onTap: (){
                                      Get.to(OrdersPage());
                                    },
                                    child: Column(
                                      children: <Widget>[

                                        Container(
                                          child: Text(medicinesViewModel.ordersCount.toString(),style: TextStyle(fontSize: 24,
                                              fontWeight: FontWeight.bold),),
                                        ),

                                        Container(
                                          child: Text("All Orders"),
                                        ),

                                      ],
                                    ),
                                  ),
                                ),

                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: <Widget>[

                                      Container(
                                        child: Text(medicinesViewModel.cartCount.toString(),style: TextStyle(fontSize: 24,
                                            fontWeight: FontWeight.bold),),
                                      ),

                                      Container(
                                        child: Text("Items in cart"),
                                      ),

                                    ],
                                  ),
                                ),

                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: <Widget>[

                                      Container(
                                        child: Text(medicinesViewModel.wishlistCount.toString(),style: TextStyle(fontSize: 24,
                                            fontWeight: FontWeight.bold),),
                                      ),

                                      Container(
                                        child: Text("Items in wishlist"),
                                      ),

                                    ],
                                  ),
                                ),


                              ],
                            ),
                          ),
                        ),

                        Positioned(
                          top: -50,
                          left: 120,
                          child: Column(
                            children: <Widget>[

                              Container(
                                height:100,
                                width: 100,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: CachedNetworkImage(
                                    imageUrl: myAccountModel.photo.value,
                                    placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator(
                                          color: greenColor,
                                        )
                                    ),
                                    errorWidget: (context, url, error) => Center(
                                      child: CircularProgressIndicator(color: greenColor,),
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(height: 24,),
                              Container(
                                child: Text(myAccountModel.name.value,style: TextStyle(
                                    fontSize: 24,fontWeight: FontWeight.bold
                                ),),
                              ),
                              Container(
                                child: Text(myAccountModel.email.value),
                              )

                            ],
                          ),
                        ),
                        Positioned(
                            right: 16,
                            top: 8,
                            child: InkWell(
                              onTap: (){
                                Get.to(AccountEditPage());
                              },
                              child: Container(
                                child: Icon(Icons.edit,color: greenColor,),
                              ),
                            )
                        )

                      ],
                    )

                  ],
                ),
              ),
            ))
        )
    );
  }
}