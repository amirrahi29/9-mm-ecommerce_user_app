import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_app/CustomClasses/ALL_COLORS.dart';
import '../view_model/MedicineViewModel.dart';
import 'OrderDetailPage.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {

  final medicinesViewModel = Get.put(MedicineViewModel());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    medicinesViewModel.getAllMedicinesOrders();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: greenColor,
            title: Text("My orders"),
          ),
            body: Obx(()=>
                medicinesViewModel.isorderLoading.value == true?
                    Center(
                      child: CircularProgressIndicator(color: greenColor,),
                    ):ListView.builder(
                itemCount: medicinesViewModel.medicineOrderList.length,
                itemBuilder: (context,index){
                  return InkWell(
                    onTap: (){
                      Get.to(OrderDetailPage(),
                      arguments: [
                        medicinesViewModel.medicineOrderList[index].orderId
                      ]);
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: <Widget>[

                        Card(
                          child: Container(
                              padding: EdgeInsets.all(16),
                              child: Row(
                                children: <Widget>[

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[

                                        Text("#${medicinesViewModel.medicineOrderList[index].orderId}",
                                          style: TextStyle(
                                              color: blackColor,
                                              fontWeight: FontWeight.bold
                                          ),),

                                        Text("Date: ${medicinesViewModel.medicineOrderList[index].dateCreated}",
                                          style: TextStyle(
                                              fontSize: 12
                                          ),),

                                        SizedBox(height: 16,),

                                        Text("Rs.${medicinesViewModel.medicineOrderList[index].totalPrice}/-",
                                          style: TextStyle(
                                              fontSize: 24,
                                              color: blackColor,
                                              fontWeight: FontWeight.bold
                                          ),),

                                      ],
                                    ),
                                  ),

                                  Icon(Icons.chevron_right_outlined)

                                ],
                              )
                          ),
                        ),

                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Card(
                            color: medicinesViewModel.medicineOrderList[index].status == "1"?
                                greenColor:redColor,
                            elevation: 16,
                            child: Container(
                              padding: EdgeInsets.all(8),
                                child: Text(medicinesViewModel.medicineOrderList[index].status == "1"?
                                "Success":"Pending",
                                  style: TextStyle(color: whiteColor),)
                            ),
                          ),
                        )

                      ],
                    ),
                  );
                }
            ))
        )
    );
  }
}
