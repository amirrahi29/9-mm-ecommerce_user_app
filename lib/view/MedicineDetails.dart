import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_app/CustomClasses/ALL_COLORS.dart';
import 'package:user_app/view_model/MedicineViewModel.dart';

import 'AddressPage.dart';

class MedicineDetails extends StatefulWidget {
  const MedicineDetails({Key? key}) : super(key: key);

  @override
  _MedicineDetailsState createState() => _MedicineDetailsState();
}

class _MedicineDetailsState extends State<MedicineDetails> {

  var data = Get.arguments;
  final medicineViewModel = Get.put(MedicineViewModel());
  CarouselController buttonCarouselController1 = CarouselController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    medicineViewModel.getProductCategory(data);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: greenColor,
            actions: [
              Obx(()=>Container(
                margin: EdgeInsets.all(16),
                child: Badge(
                  badgeContent: Text(medicineViewModel.cartCount.toString(),
                    style: TextStyle(color: whiteColor),),
                  child: Icon(Icons.shopping_bag_outlined,
                    size: 24,color: whiteColor,),
                ),
              ))
            ],
          ),
          body: Obx(()=>Stack(
            clipBehavior: Clip.none,
            children: <Widget>[

              SingleChildScrollView(
                child: Obx(()=>Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    Stack(
                      clipBehavior: Clip.none,
                      children: <Widget>[

                        Container(
                            height: 150,
                            width: double.infinity,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color: greenColor,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(16),
                                  bottomRight: Radius.circular(16),
                                )
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[

                                Container(
                                  child: Text(data.title!,style: TextStyle(color: whiteColor,
                                      fontSize: 24,fontWeight: FontWeight.bold),),
                                ),

                                Container(
                                  child: Text(medicineViewModel.categoryName.value == ""?'':"Category: "+
                                      medicineViewModel.categoryName.toString(),
                                    style: TextStyle(color: whiteColor,
                                        fontSize: 16),),
                                ),

                              ],
                            )
                        ),

                        Positioned(
                          bottom: -50,
                          right: 8,
                          child: Card(
                            elevation: 10,
                            shape: BeveledRectangleBorder(
                                borderRadius: BorderRadius.circular(8)
                            ),
                            child: Container(
                              height:100,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  imageUrl: data.medicineImage!,
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
                          ),
                        ),

                        Positioned(
                            bottom: 0,
                            left: 0,
                            child: Container(
                              margin: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[

                                  Text("Price ",
                                    style: TextStyle(fontSize: 16,
                                        color: whiteColor),),

                                  Text("Rs. "+data.price!.toString(),
                                    style: TextStyle(fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: whiteColor),)

                                ],
                              ),
                            )
                        )

                      ],
                    ),

                    medicineViewModel.wishList.contains(data)
                        ?InkWell(
                      onTap: (){
                        medicineViewModel.toggleWishlist(data);
                      },
                      child: Container(
                        margin: EdgeInsets.all(16),
                        child: Icon(Icons.favorite,
                          color: redColor,size: 48,),
                      ),
                    ):
                    InkWell(
                      onTap: (){
                        medicineViewModel.toggleWishlist(data);
                      },
                      child: Container(
                        margin: EdgeInsets.all(16),
                        child: Icon(Icons.favorite_border,
                          color: greenColor,size: 48,),
                      ),
                    ),

                    SizedBox(height: 24,),

                    Container(
                      margin: EdgeInsets.all(8),
                      child: Text("Category",
                        style: TextStyle(fontSize: 20,
                            fontWeight: FontWeight.bold),),
                    ),
                    Divider(
                      height: 1,
                      color: greenColor,
                    ),
                    Container(
                      margin: EdgeInsets.all(8),
                      child: Text(medicineViewModel.categoryName.value==""?'':
                      medicineViewModel.categoryName.toString(),
                        style: TextStyle(fontSize: 16),),
                    ),

                    SizedBox(height: 8,),

                    Container(
                      margin: EdgeInsets.all(8),
                      child: Text("Descriptions",
                        style: TextStyle(fontSize: 20,
                            fontWeight: FontWeight.bold),),
                    ),
                    Divider(
                      height: 1,
                      color: greenColor,
                    ),
                    Container(
                      margin: EdgeInsets.all(8),
                      child: Text(data.description!,
                        style: TextStyle(fontSize: 16),),
                    ),

                    SizedBox(height: 8,),

                    Container(
                      margin: EdgeInsets.all(8),
                      child: Text("Added date",
                        style: TextStyle(fontSize: 20,
                            fontWeight: FontWeight.bold),),
                    ),
                    Divider(
                      height: 1,
                      color: greenColor,
                    ),
                    Container(
                      margin: EdgeInsets.all(8),
                      child: Text(data.date!,
                        style: TextStyle(fontSize: 16),),
                    ),

                    offerMedicines(),

                    SizedBox(height: 80,)

                  ],
                )),
              ),

              Container(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.all(8),
                child: Row(
                  children: <Widget>[

                    if(!medicineViewModel.cartList.contains(data))
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: (){
                            medicineViewModel.addToCart(data);
                          },
                          child: Container(
                              margin: EdgeInsets.only(right: 2),
                              padding:EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                  color: greenColor,
                                  borderRadius: BorderRadius.circular(8)
                              ),
                              child: Row(
                                children: <Widget>[

                                  Icon(Icons.add,color: whiteColor,),
                                  SizedBox(width: 8,),
                                  Text("Add to cart",
                                    style: TextStyle(color: whiteColor,
                                        fontSize: 20),),

                                ],
                              )
                          ),
                        ),
                      )
                    else
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 60,
                            margin: EdgeInsets.only(right: 2),
                            padding:EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color: greenColor,
                                borderRadius: BorderRadius.circular(8)
                            ),
                            child: Row(
                              children: <Widget>[

                                InkWell(
                                  onTap:(){
                                    medicineViewModel.removeUpdateCart(data);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: whiteColor,
                                        borderRadius: BorderRadius.circular(100)
                                    ),
                                    child: Icon(Icons.remove,color: greenColor,),
                                  ),
                                ),

                                Expanded(
                                    child: Container(
                                        alignment: Alignment.center,
                                        child: Text(data.qty.toString(),style: TextStyle(color: whiteColor,
                                            fontSize: 20),)
                                    )
                                ),

                                InkWell(
                                  onTap: (){
                                    medicineViewModel.updateCart(data);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: whiteColor,
                                        borderRadius: BorderRadius.circular(100)
                                    ),
                                    child: Icon(Icons.add,color: greenColor,),
                                  ),
                                )

                              ],
                            )
                        ),
                      ),

                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: (){
                          Get.to(AddressPage());
                        },
                        child: Container(
                            margin: EdgeInsets.only(left: 2),
                            padding:EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color: redDarkColor,
                                borderRadius: BorderRadius.circular(8)
                            ),
                            child: Row(
                              children: <Widget>[

                                Expanded(
                                  child: Text("Checkout",
                                    style: TextStyle(color: whiteColor,
                                        fontSize: 20),),
                                ),
                                SizedBox(width: 16,),
                                Icon(Icons.arrow_forward_ios_outlined,
                                  color: whiteColor,)

                              ],
                            )
                        ),
                      ),
                    )

                  ],
                ),
              ),

            ],
          ))
        )
    );
  }

  Widget offerMedicines(){
    List<Widget> items1 = [
      for(int i = 0; i<medicineViewModel.medicineList.length; i++)
        InkWell(
          onTap: (){
            Navigator.pop(context);
            Get.to(MedicineDetails(),
                arguments: medicineViewModel.medicineList[i]);
          },
          child: Card(
            elevation:6,
            child: Container(
              padding:EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  Expanded(
                    child: CachedNetworkImage(
                      imageUrl: medicineViewModel.medicineList[i].medicineImage!,
                      placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(
                            color: greenColor,
                          )
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      fit: BoxFit.cover,
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 8),
                    child: Text("Rs."+medicineViewModel.medicineList[i].price!.toString(),
                      style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  ),

                  SizedBox(height: 2,),

                  Container(
                    child: Text(medicineViewModel.medicineList[i].title!,),
                  ),

                ],
              ),
            ),
          ),
        ),
    ];
    return Container(
      margin: EdgeInsets.only(top: 16,left: 8,right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(8),
            child: Text("Related items",
              style: TextStyle(fontSize: 20,
                  fontWeight: FontWeight.bold),),
          ),
          Divider(
            height: 1,
            color: greenColor,
          ),
          CarouselSlider(
            items: items1,
            carouselController: buttonCarouselController1,
            options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 0.4,
              aspectRatio: 3.0,
              initialPage: 2,
            ),
          )

        ],
      ),
    );
  }

}
