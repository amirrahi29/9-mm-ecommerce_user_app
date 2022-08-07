import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_app/view_model/CategoryViewModel.dart';
import '../../CustomClasses/ALL_COLORS.dart';
import '../../CustomClasses/ALL_IMAGES.dart';
import '../../view_model/MedicineViewModel.dart';
import '../CategoryRelatedMedicines.dart';
import '../Drawer/LeftDrawer.dart';

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<Categories> {

  final medicinesViewModel = Get.put(MedicineViewModel());
  final categoriesViewModel = Get.put(CategoryViewModel());
  final GlobalKey<ScaffoldState> _key = GlobalKey();

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
            body: Obx(() =>
                categoriesViewModel.isCategoryLoading.value == true?
                    Center(
                      child: CircularProgressIndicator(
                        color: greenColor,
                      ),
                    ):
                Container(
                  margin: EdgeInsets.all(8),
                  alignment: Alignment.center,
                  child: categoriesViewModel.categoryList.isEmpty?
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      Icon(Icons.favorite_border,color: greenColor,
                        size: 84,),

                      Text("No categories",
                        style: TextStyle(fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: greenColor),),

                    ],
                  )
                      :GridView.count(
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1.3,
                    crossAxisCount: 2,
                    children: <Widget>[

                      for(int i = 0; i<categoriesViewModel.categoryList.length; i++)
                        InkWell(
                          onTap: (){
                            Get.to(CategoryRelatedMedicines(),
                                arguments: [
                                  categoriesViewModel.categoryList[i].uid!,
                                  categoriesViewModel.categoryList[i].title!,
                                ]);
                          },
                          child: Stack(
                            children: <Widget>[

                              CachedNetworkImage(
                                imageUrl: categoriesViewModel.categoryList[i].catImage!,
                                placeholder: (context, url) => Center(
                                    child: CircularProgressIndicator(
                                      color: greenColor,
                                    )
                                ),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                                fit: BoxFit.cover,
                              ),

                              Positioned(
                                bottom: 16,
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: greenColor
                                  ),
                                  child: Text(categoriesViewModel.categoryList[i].title!,
                                    style: TextStyle(color: whiteColor),),
                                ),
                              )

                            ],
                          ),
                        )

                    ],
                  ),
                ),
            )
        )
    );
  }
}