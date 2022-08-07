import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_app/CustomClasses/ALL_COLORS.dart';
import '../view_model/MedicineViewModel.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({Key? key}) : super(key: key);

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {

  final medicinesViewModel = Get.put(MedicineViewModel());
  var orderId = Get.arguments;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    medicinesViewModel.getAllOrderProducts(orderId[0].toString());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: greenColor,
              //title: Text("My order details"),
              title: Text("${orderId[0]}"),
            ),
            body: Obx(()=>
            medicinesViewModel.isorderDetailsLoading.value == true?
            Center(
              child: CircularProgressIndicator(color: greenColor,),
            ):ListView.builder(
                itemCount: medicinesViewModel.medicineOrderProductList.length,
                itemBuilder: (context,index){
                  return InkWell(
                    onTap: (){
                      Get.to(OrderDetailPage());
                    },
                    child: Card(
                      child: Container(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[

                              Row(
                                children: <Widget>[

                                  Container(
                                    height: 50,
                                    width: 50,
                                    child: CachedNetworkImage(
                                      imageUrl: medicinesViewModel.medicineOrderProductList[index].medicineImage!,
                                      placeholder: (context, url) => Center(
                                          child: CircularProgressIndicator(
                                            color: greenColor,
                                          )
                                      ),
                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                      fit: BoxFit.contain,
                                    ),
                                  ),

                                  SizedBox(width: 16,),

                                  Expanded(
                                    child: Text("${medicinesViewModel.medicineOrderProductList[index].title}",
                                      style: TextStyle(
                                          color: blackColor,
                                          fontWeight: FontWeight.bold
                                      ),),
                                  ),

                                ],
                              ),
                              Text("Rs.${medicinesViewModel.medicineOrderProductList[index].price.toString()}",
                                style: TextStyle(
                                    color: blackColor,
                                    fontWeight: FontWeight.bold,
                                  fontSize: 20
                                ),),

                            ],
                          ),
                      ),
                    ),
                  );
                }
            ))
        )
    );
  }
}
