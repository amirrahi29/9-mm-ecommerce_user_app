import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_app/CustomClasses/ALL_COLORS.dart';
import 'package:user_app/view/MedicineDetails.dart';
import 'package:user_app/view_model/MedicineViewModel.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  final searchController = TextEditingController();
  final medicineViewModel = Get.put(MedicineViewModel());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: greenColor,
            title: TextField(
              onChanged: (value){
                medicineViewModel.searchMedicines(value);
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
                  },
                    child: Icon(Icons.close,color: whiteColor,)),
              ),
              style: TextStyle(color: whiteColor),
            )
          ),
          body: Obx(()=>medicineViewModel.searchMedicineList.length<=0?
          Center(
            child: Text("No medicines",
              style: TextStyle(fontSize: 24,color: greenColor),),
          ):ListView.builder(
              itemCount: medicineViewModel.searchMedicineList.length,
              itemBuilder: (context,index){
                return InkWell(
                  onTap: (){
                    Get.to(MedicineDetails(),
                        arguments: medicineViewModel.searchMedicineList[index]);
                  },
                  child: Card(
                    child: Container(
                        child: Row(
                          children: <Widget>[

                            Column(
                              children: <Widget>[

                                Container(
                                  height: 70,
                                  width: 70,
                                  child: CachedNetworkImage(
                                    imageUrl: medicineViewModel.searchMedicineList[index].medicineImage!,
                                    placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator(
                                          color: greenColor,
                                        )
                                    ),
                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                    fit: BoxFit.contain,
                                  ),
                                ),

                              ],
                            ),

                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(left: 8,right: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[

                                    Container(
                                      child: Text(medicineViewModel.searchMedicineList[index].title!,
                                        style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                    ),

                                    Container(
                                      child: Text("Rs. "+medicineViewModel.searchMedicineList[index].price!.toString(),
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
          )),
        )
    );
  }
}
