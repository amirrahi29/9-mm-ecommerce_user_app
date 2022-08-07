import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_app/view/HomePage.dart';
import 'package:user_app/view_model/MedicineViewModel.dart';
import '../CustomClasses/ALL_COLORS.dart';
import '../CustomClasses/ALL_IMAGES.dart';

class PaymentStatus extends StatefulWidget {
  const PaymentStatus({Key? key}) : super(key: key);

  @override
  _PaymentStatusState createState() => _PaymentStatusState();
}

class _PaymentStatusState extends State<PaymentStatus> {

  var data = Get.arguments;
  int uniqueId = DateTime.now().microsecondsSinceEpoch;
  final medicineViewmodel = Get.put(MedicineViewModel());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    medicineViewmodel.submitOrders(uniqueId.toString(),data[0]);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Stack(
            children: <Widget>[

              Container(
                alignment: Alignment.center,
                child: data[0] == "0"?
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    Container(
                      height:150,
                      width: 150,
                      child: Image.asset(errorImage),
                    ),

                    SizedBox(height: 32,),

                    Container(
                      child: Text("Order id: $uniqueId",
                        style: TextStyle(fontSize: 20,
                            fontWeight: FontWeight.bold),),
                    ),

                    Container(
                      child: Text("Your order have been declined!",
                        style: TextStyle(fontSize: 16),),
                    )

                  ],
                ) :
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    Container(
                      height:150,
                      width: 150,
                      child: Image.asset(successImage),
                    ),

                    SizedBox(height: 32,),

                    Container(
                      child: Text("Order id: $uniqueId",
                        style: TextStyle(fontSize: 20,
                            fontWeight: FontWeight.bold),),
                    ),

                    Container(
                      child: Text("Your order have been successfully placed!",
                        style: TextStyle(fontSize: 16),),
                    )

                  ],
                ),
              ),

              Positioned(
                bottom: 0,
                child: InkWell(
                  onTap: (){
                    Get.offAll(HomePage());
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: greenColor
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: Text("Go to home",
                    style: TextStyle(fontSize: 20,color: whiteColor),),
                  ),
                ),
              )

            ],
          ),
        )
    );
  }
}
