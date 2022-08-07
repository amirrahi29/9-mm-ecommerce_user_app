import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_app/CustomClasses/ALL_COLORS.dart';
import 'package:user_app/CustomClasses/ALL_IMAGES.dart';
import 'package:user_app/view/CategoryRelatedMedicines.dart';
import 'package:user_app/view/Drawer/LeftDrawer.dart';
import 'package:user_app/view/MedicineDetails.dart';
import 'package:user_app/view/SearchPage.dart';
import 'package:user_app/view_model/BannerViewModel.dart';
import 'package:user_app/view_model/CategoryViewModel.dart';
import 'package:user_app/view_model/MedicineViewModel.dart';

class ProductsHomePage extends StatefulWidget {
  const ProductsHomePage({Key? key}) : super(key: key);

  @override
  _ProductsHomePageState createState() => _ProductsHomePageState();
}

class _ProductsHomePageState extends State<ProductsHomePage> {

  final bannerViewModel = Get.put(BannerViewModel());
  final categoriesViewModel = Get.put(CategoryViewModel());
  final medicinesViewModel = Get.put(MedicineViewModel());
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  CarouselController buttonCarouselController = CarouselController();
  CarouselController buttonCarouselController1 = CarouselController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
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
            ))
          ),
          key: _key,
          drawer: LeftDrawer(),
          body: Obx(()=>
          medicinesViewModel.isMedicineLoading.value == true?
              Center(
                child:CircularProgressIndicator(
                  color: greenColor,
                )
              ):
              ListView(
                children: <Widget>[
                  offerMedicines(),
                  searchWidget(),
                  InTrendsWidget(),
                  bannerWidget(),
                  categoryWidget(),
                  popularMedicinesWidget(),
                  SizedBox(height: 24,)

                ],
              ),
          )
        )
    );
  }
  Widget offerMedicines(){
    List<Widget> items1 = [
      for(int i = 0; i<medicinesViewModel.medicineList.length; i++)
        InkWell(
          onTap: (){
            Get.to(MedicineDetails(),
                arguments: medicinesViewModel.medicineList[i]);
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
                      imageUrl: medicinesViewModel.medicineList[i].medicineImage!,
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
                    child: Text("Rs."+medicinesViewModel.medicineList[i].price!.toString(),
                      style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  ),

                  SizedBox(height: 2,),

                  Container(
                    child: Text(medicinesViewModel.medicineList[i].title!,),
                  ),

                ],
              ),
            ),
          ),
        ),
    ];
    return Container(
      margin: EdgeInsets.only(top: 16,left: 8,right: 16),
      child: CarouselSlider(
        items: items1,
        carouselController: buttonCarouselController1,
        options: CarouselOptions(
          autoPlay: true,
          enlargeCenterPage: true,
          viewportFraction: 0.4,
          aspectRatio: 3.0,
          initialPage: 2,
        ),
      ),
    );
  }
  Widget searchWidget(){
    return Container(
      margin: EdgeInsets.only(left: 16,right: 16,top: 8),
      child: TextField(
        readOnly: true,
        onTap: (){
          Get.to(SearchPage());
        },
        onChanged: (value){
          print(value);
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          prefixIcon: Icon(Icons.search),
          hintText: 'Search here...'
        ),
      ),
    );
  }
  Widget InTrendsWidget(){
    return Container(
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[

          InkWell(
            onTap: (){
              Get.to(SearchPage());
            },
            child: Container(
                margin: EdgeInsets.all(8),
                child: Row(
                  children: <Widget>[

                    Expanded(
                      child: Text("Medicines in trend",style: TextStyle(fontSize: 20,
                          fontWeight: FontWeight.bold),),
                    ),

                    Text("See more",style: TextStyle(fontSize: 14,),),

                  ],
                )
            ),
          ),

          SizedBox(
            height: 150,
            child: ListView.builder(
                itemCount: medicinesViewModel.medicineList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context,index){
                  return InkWell(
                    onTap: (){
                      Get.to(MedicineDetails(),
                          arguments: medicinesViewModel.medicineList[index]);
                    },
                    child: Card(
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[

                            Container(
                              height:50,
                              child: CachedNetworkImage(
                                imageUrl: medicinesViewModel.medicineList[index].medicineImage!,
                                placeholder: (context, url) => Center(
                                    child: CircularProgressIndicator(
                                      color: greenColor,
                                    )
                                ),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                                fit: BoxFit.cover,
                              ),
                            ),

                            SizedBox(height: 16,),

                            Container(
                              height: 25,
                              child: Text(medicinesViewModel.medicineList[index].title!,
                                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                            ),

                            Container(
                              child: Column(
                                children: <Widget>[

                                  if(!medicinesViewModel.cartList.contains(medicinesViewModel.medicineList[index]))
                                  InkWell(
                                    onTap:(){
                                      medicinesViewModel.addToCart(medicinesViewModel.medicineList[index]);
                                    },
                                    child: Container(
                                      padding:EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: greenColor,
                                      ),
                                      child: Text("Add to cart",style: TextStyle(color: whiteColor),),
                                    ),
                                  ),
                                  if(medicinesViewModel.cartList.contains(medicinesViewModel.medicineList[index]))
                                  Container(
                                    padding:EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: greenColor,
                                    ),
                                    child: Row(
                                      children: <Widget>[

                                        InkWell(
                                          onTap:(){
                                            medicinesViewModel.removeUpdateCart(medicinesViewModel.medicineList[index]);
                                          },
                                          child: Container(
                                            decoration:BoxDecoration(
                                              color: greenColor,
                                              borderRadius: BorderRadius.circular(100)
                                            ),
                                              child: Icon(Icons.remove,size: 16,color: whiteColor,)),
                                        ),

                                        Container(
                                          margin: EdgeInsets.only(left: 16,right: 16),
                                            child: Text(medicinesViewModel.medicineList[index].qty.toString(),
                                              style: TextStyle(color: whiteColor),)),

                                        InkWell(
                                          onTap: (){
                                            medicinesViewModel.updateCart(medicinesViewModel.medicineList[index]);
                                          },
                                          child: Container(
                                              decoration:BoxDecoration(
                                                  color: greenColor,
                                                  borderRadius: BorderRadius.circular(100)
                                              ),
                                              child: Icon(Icons.add,size: 16,color: whiteColor,)),
                                        ),

                                      ],
                                    )
                                  )

                                ],
                              ),
                            )

                          ],
                        ),
                      ),
                    ),
                  );
                }
            ),
          )

        ],
      ),
    );
  }
  Widget bannerWidget(){
    List<Widget> items = [
      for(int i = 0; i<bannerViewModel.bannerList.length; i++)
        CachedNetworkImage(
          imageUrl: bannerViewModel.bannerList[i].bannerImage!,
          placeholder: (context, url) => Center(
              child: CircularProgressIndicator(
                color: greenColor,
              )
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
          fit: BoxFit.cover,
        ),
    ];
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8)
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[

          CarouselSlider(
            items: items,
            carouselController: buttonCarouselController,
            options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 0.6,
              aspectRatio: 3.0,
              initialPage: 2,
            ),
          ),

          Positioned(
              left: 100,
              bottom: 0,
              child: InkWell(
                  onTap: (){
                    buttonCarouselController.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.linear);
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                      child: Icon(Icons.arrow_back_ios_new_outlined,
                        color: blackColor,))
              )
          ),

          Positioned(
              right: 100,
              bottom: 0,
              child: InkWell(
                  onTap: (){
                    buttonCarouselController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.linear);
                  },
                  child: Container(
                      padding: EdgeInsets.all(8),
                      child: Icon(Icons.arrow_forward_ios_outlined,
                        color: blackColor,))
              )
          )

        ],
      ),
    );
  }
  Widget categoryWidget(){
    return Container(
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[

          Container(
            margin: EdgeInsets.all(8),
            child:  Text("Category",style: TextStyle(fontSize: 20,
                fontWeight: FontWeight.bold),),
          ),

          SizedBox(
            height: 120,
            child: ListView.builder(
              itemCount: categoriesViewModel.categoryList.length,
              scrollDirection: Axis.horizontal,
                itemBuilder: (context,index){
                  return InkWell(
                    onTap: (){
                      Get.to(CategoryRelatedMedicines(),
                          arguments: [
                            categoriesViewModel.categoryList[index].uid!,
                            categoriesViewModel.categoryList[index].title!,
                          ]);
                    },
                    child: Card(
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[

                            Container(
                              height:50,
                              child: CachedNetworkImage(
                                imageUrl: categoriesViewModel.categoryList[index].catImage!,
                                placeholder: (context, url) => Center(
                                    child: CircularProgressIndicator(
                                      color: greenColor,
                                    )
                                ),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                                fit: BoxFit.cover,
                              ),
                            ),

                            SizedBox(height: 16,),

                            Container(
                              height: 25,
                              child: Text(categoriesViewModel.categoryList[index].title!,
                              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                            )

                          ],
                        ),
                      ),
                    ),
                  );
                }
            ),
          )

        ],
      ),
    );
  }
  Widget popularMedicinesWidget(){
    return Container(
      margin: EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[

          InkWell(
            onTap: (){
              Get.to(SearchPage());
            },
            child: Container(
                margin: EdgeInsets.all(8),
                child: Row(
                  children: <Widget>[

                    Expanded(
                      child: Text("Popular",style: TextStyle(fontSize: 20,
                          fontWeight: FontWeight.bold),),
                    ),

                    Text("See more",style: TextStyle(fontSize: 14,),),

                  ],
                )
            ),
          ),

          SizedBox(
            height: 700,
              child: GridView.count(
                physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                children: <Widget>[

                  if(medicinesViewModel.medicineList.length >=8)
                  for(int i = 0; i<8; i++)
                  Stack(
                    clipBehavior: Clip.none,
                    children: <Widget>[

                      InkWell(
                        onTap: (){
                          Get.to(MedicineDetails(),
                          arguments: medicinesViewModel.medicineList[i]);
                        },
                        child: Card(
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[

                                Container(
                                  height:70,
                                  child: CachedNetworkImage(
                                    imageUrl: medicinesViewModel.medicineList[i].medicineImage!,
                                    placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator(
                                          color: greenColor,
                                        )
                                    ),
                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                    fit: BoxFit.cover,
                                  ),
                                ),

                                SizedBox(height: 16,),

                                Container(
                                  height: 25,
                                  child: Text(medicinesViewModel.medicineList[i].title!,
                                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                                )

                              ],
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        top: 8,
                        left: 8,
                        child: InkWell(
                          onTap: (){
                            medicinesViewModel.toggleWishlist(medicinesViewModel.medicineList[i]);
                          },
                          child: Container(
                            child: medicinesViewModel.wishList.contains(medicinesViewModel.medicineList[i])?
                            Icon(Icons.favorite, color: redColor,):Icon(Icons.favorite_border, color: greenColor,),
                          ),
                        ),
                      ),

                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: InkWell(
                          onTap: (){
                            medicinesViewModel.cartList.contains(medicinesViewModel.medicineList[i])?
                            medicinesViewModel.removeFromCart(medicinesViewModel.medicineList[i]):
                            medicinesViewModel.addToCart(medicinesViewModel.medicineList[i]);
                          },
                          child: Container(
                            padding: EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              color: medicinesViewModel.cartList.contains(medicinesViewModel.medicineList[i])?redColor:greenColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              )
                            ),
                            child: medicinesViewModel.cartList.contains(medicinesViewModel.medicineList[i])
                            ?Icon(Icons.remove, color: whiteColor,size: 18,):Icon(Icons.add, color: whiteColor,size: 18,),
                          ),
                        ),
                      )

                    ],
                  )

                  else
                    Center(
                      child: Text("No products or less than 8 products!"),
                    )

                ],
              )
          )

        ],
      ),
    );
  }
}
