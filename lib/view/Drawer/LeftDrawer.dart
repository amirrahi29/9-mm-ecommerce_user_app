import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:user_app/CustomClasses/ALL_COLORS.dart';
import 'package:user_app/CustomClasses/SingeltonClass.dart';
import 'package:user_app/view/AddressPage.dart';
import 'package:user_app/view/OrdersPage.dart';
import 'package:user_app/view_model/AccountViewModel.dart';

import '../AccountEditPage.dart';

class LeftDrawer extends StatefulWidget {
  const LeftDrawer({Key? key}) : super(key: key);

  @override
  _LeftDrawerState createState() => _LeftDrawerState();
}

class _LeftDrawerState extends State<LeftDrawer> {

  final accountViewModel = Get.put(AccountViewModel());

  @override
  Widget build(BuildContext context) {
    return Obx(()=>Container(
      width: MediaQuery.of(context).size.width/1.2,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[

          SafeArea(
              child: Scaffold(
                  body: SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[

                          SizedBox(height: 20,),
                          Container(
                            height:100,
                            width: 100,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: CachedNetworkImage(
                                imageUrl: accountViewModel.photo.value,
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
                          SizedBox(height: 16,),

                         InkWell(
                           onTap: (){
                             Get.to(AccountEditPage());
                           },
                           child: Row(
                             children: <Widget>[

                               Container(
                                 child: Text(accountViewModel.name.value,style: TextStyle(fontSize: 20,
                                     fontWeight: FontWeight.bold),),
                               ),

                               SizedBox(width: 8,),

                               Container(
                                 child: Icon(Icons.edit,size: 20,),
                               ),
                             ],
                           ),
                         ),

                          Container(
                            child: Text(accountViewModel.email.value,
                              style: TextStyle(fontSize: 16),),
                          ),

                          Divider(
                            color: greenColor,
                          ),
                          SizedBox(height: 24,),

                          InkWell(
                            onTap: (){
                              Get.to(OrdersPage());
                            },
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[

                                    Container(
                                        margin: EdgeInsets.all(8),
                                        child: Icon(Icons.description,
                                          color: greenColor,)
                                    ),

                                    Container(
                                      child: Text("Track orders"),
                                    ),

                                    Expanded(
                                      child: Container(
                                          alignment: Alignment.centerRight,
                                          child: Icon(Icons.keyboard_arrow_right_outlined,
                                            color: greenColor,)
                                      ),
                                    )

                                  ],
                                ),
                                Divider(color: greenColor,)
                              ],
                            ),
                          ),

                          InkWell(
                            onTap: (){
                              Get.to(AddressPage());
                            },
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[

                                    Container(
                                        margin: EdgeInsets.all(8),
                                        child: Icon(Icons.add,
                                          color: greenColor,)
                                    ),

                                    Container(
                                      child: Text("My Addresses"),
                                    ),

                                    Expanded(
                                      child: Container(
                                          alignment: Alignment.centerRight,
                                          child: Icon(Icons.keyboard_arrow_right_outlined,
                                            color: greenColor,)
                                      ),
                                    )

                                  ],
                                ),
                                Divider(color: greenColor,)
                              ],
                            ),
                          ),

                          Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[

                                  Container(
                                      margin: EdgeInsets.all(8),
                                      child: Icon(Icons.person_outline,color: greenColor,)
                                  ),

                                  Container(
                                    child: Text("About Us"),
                                  ),

                                  Expanded(
                                    child: Container(
                                        alignment: Alignment.centerRight,
                                        child: Icon(Icons.keyboard_arrow_right_outlined,
                                          color: greenColor,)
                                    ),
                                  )

                                ],
                              ),
                              Divider(color: greenColor,)
                            ],
                          ),

                          Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[

                                  Container(
                                      margin: EdgeInsets.all(8),
                                      child: Icon(Icons.search,color: greenColor,)
                                  ),

                                  Container(
                                    child: Text("Search"),
                                  ),

                                  Expanded(
                                    child: Container(
                                        alignment: Alignment.centerRight,
                                        child: Icon(Icons.keyboard_arrow_right_outlined,
                                          color: greenColor,)
                                    ),
                                  )

                                ],
                              ),
                              Divider(color: greenColor,)
                            ],
                          ),

                          InkWell(
                            onTap: (){
                              Share.share('check out my website https://example.com',
                                  subject: 'Look what I made!');
                            },
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[

                                    Container(
                                        margin: EdgeInsets.all(8),
                                        child: Icon(Icons.share,color: greenColor,)
                                    ),

                                    Container(
                                      child: Text("Share"),
                                    ),

                                    Expanded(
                                      child: Container(
                                          alignment: Alignment.centerRight,
                                          child: Icon(Icons.keyboard_arrow_right_outlined,
                                            color: greenColor,)
                                      ),
                                    )

                                  ],
                                ),
                                Divider(color: greenColor,)
                              ],
                            ),
                          ),

                          InkWell(
                            onTap: ()async{
                              await launchUrl(Uri.parse('https://flutter.dev'));
                            },
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[

                                    Container(
                                        margin: EdgeInsets.all(8),
                                        child: Icon(Icons.star,color: greenColor,)
                                    ),

                                    Container(
                                      child: Text("Rate on playstore"),
                                    ),

                                    Expanded(
                                      child: Container(
                                          alignment: Alignment.centerRight,
                                          child: Icon(Icons.keyboard_arrow_right_outlined,
                                            color: greenColor,)
                                      ),
                                    )

                                  ],
                                ),
                                Divider(color: greenColor,)
                              ],
                            ),
                          ),

                          InkWell(
                            onTap: (){
                              SingeltonClass().logoutUser();
                            },
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[

                                    Container(
                                        margin: EdgeInsets.all(8),
                                        child: Icon(Icons.exit_to_app,color: greenColor,)
                                    ),

                                    Container(
                                      child: Text("SignOut"),
                                    ),

                                    Expanded(
                                      child: Container(
                                          alignment: Alignment.centerRight,
                                          child: Icon(Icons.keyboard_arrow_right_outlined,
                                            color: greenColor,)
                                      ),
                                    )

                                  ],
                                ),
                                Divider(color: greenColor,)
                              ],
                            ),
                          ),


                        ],
                      ),
                    ),
                  )
              )
          ),
          Positioned(
            right: -50,
            top: 16,
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                  color: redColor,
                  borderRadius: BorderRadius.circular(100)
              ),
              child: Icon(Icons.close,color: whiteColor,),
            ),
          )

        ],
      ),
    ));
  }
}
