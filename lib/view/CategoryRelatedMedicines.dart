import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_app/view/MedicineDetails.dart';

import '../CustomClasses/ALL_COLORS.dart';
import '../view_model/CategoryViewModel.dart';

class CategoryRelatedMedicines extends StatefulWidget {
  const CategoryRelatedMedicines({Key? key}) : super(key: key);

  @override
  _CategoryRelatedMedicinesState createState() => _CategoryRelatedMedicinesState();
}

class _CategoryRelatedMedicinesState extends State<CategoryRelatedMedicines> {

  final searchController = TextEditingController();
  final categoryViewModel = CategoryViewModel();
  var data = Get.arguments;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    categoryViewModel.fetchAllCategoryRelatedMedicines(data[0].toString());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: greenColor,
              title: TextField(
                onChanged: (values){
                  categoryViewModel.searchMedicines(values);
                },
                controller: searchController,
                cursorColor: whiteColor,
                decoration: InputDecoration(
                  hintText: 'Search here...',
                  hintStyle: TextStyle(
                      color: whiteColor
                  ),
                  suffixIcon: InkWell(
                      onTap: (){
                        searchController.text = "";
                        categoryViewModel.searchMedicines("");
                      },
                      child: Icon(Icons.close,color: whiteColor,)),
                ),
                style: TextStyle(color: whiteColor),
              )
          ),
          body: Obx(()=>categoryViewModel.isCategoryRelatedMedicinesLoading.value == true?
          Center(
            child: CircularProgressIndicator(
              color: greenColor,
            ),
          ):
          categoryViewModel.categoryRelatedMedicinesList.length <=0?
          Center(
            child: Text("No medicines",
              style: TextStyle(fontSize: 24,color: greenColor),),
          ):
          Stack(
            children: <Widget>[

              Container(
                margin: EdgeInsets.only(top: 45),
                child: ListView.builder(
                    itemCount: categoryViewModel.categoryRelatedMedicinesList.length,
                    itemBuilder: (context,index){
                      return InkWell(
                        onTap: (){
                          Get.to(MedicineDetails(),arguments: categoryViewModel.categoryRelatedMedicinesList[index]);
                        },
                        child: Card(
                          child: Container(
                              padding: EdgeInsets.all(8),
                              child: Row(
                                children: <Widget>[

                                  Column(
                                    children: <Widget>[

                                      Container(
                                        height: 70,
                                        width: 70,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(16),
                                          child: CachedNetworkImage(
                                            imageUrl: categoryViewModel.categoryRelatedMedicinesList[index].medicineImage!,
                                            placeholder: (context, url) => Center(
                                                child: CircularProgressIndicator(
                                                  color: greenColor,
                                                )
                                            ),
                                            errorWidget: (context, url, error) => Icon(Icons.error),
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      )

                                    ],
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(left: 8,right: 8),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[

                                          Container(
                                            child: Text(categoryViewModel.categoryRelatedMedicinesList[index].title!,
                                              style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                          ),

                                          Container(
                                            child: Text("Rs. "+categoryViewModel.categoryRelatedMedicinesList[index].price!.toString(),
                                              style: TextStyle(fontSize: 16),),
                                          )

                                        ],
                                      ),
                                    ),
                                  )

                                ],
                              )
                          ),
                        ),
                      );
                    }
                ),
              ),

              Positioned(
                top: 0,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: greenColor
                    ),
                    margin: EdgeInsets.all(8),
                    child: Text(data[1],
                      style: TextStyle(fontSize: 16,
                          fontWeight: FontWeight.bold,
                      color: whiteColor),),
                  ),
              )

            ],
          ),
          )
        )
    );
  }
}
