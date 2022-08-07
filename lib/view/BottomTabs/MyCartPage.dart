import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_app/CustomClasses/ALL_COLORS.dart';
import 'package:user_app/view/AddressPage.dart';
import '../../CustomClasses/ALL_IMAGES.dart';
import '../../view_model/MedicineViewModel.dart';
import '../Drawer/LeftDrawer.dart';

class MyCartPage extends StatefulWidget {
  const MyCartPage({Key? key}) : super(key: key);

  @override
  _MyCartPageState createState() => _MyCartPageState();
}

class _MyCartPageState extends State<MyCartPage> {

  final medicinesViewModel = Get.put(MedicineViewModel());
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
                Stack(
                  children: <Widget>[

                    Container(
                      margin: EdgeInsets.all(8),
                      alignment: Alignment.center,
                      child: medicinesViewModel.cartCount == 0?
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[

                          Icon(Icons.shopping_bag_outlined,color: greenColor,
                            size: 84,),

                          Text("No items in cart",
                            style: TextStyle(fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: greenColor),),

                        ],
                      )
                          :ListView.builder(
                          itemCount: medicinesViewModel.cartList.length,
                          itemBuilder: (context,index){
                            return Column(
                              children: <Widget>[

                                Row(
                                  children: <Widget>[

                                    Container(
                                      height:70,
                                      width: 70,
                                      margin: EdgeInsets.all(8),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(100),
                                        child: CachedNetworkImage(
                                          imageUrl: medicinesViewModel.cartList[index].medicineImage!,
                                          placeholder: (context, url) => Center(
                                              child: CircularProgressIndicator()
                                          ),
                                          errorWidget: (context, url, error) => Icon(Icons.error),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[

                                          Container(
                                            child: Text(medicinesViewModel.cartList[index].title!,
                                              style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                          ),
                                          SizedBox(height: 4,),

                                          Row(
                                            children: <Widget>[

                                              Container(
                                                child: Text("Rs. "+medicinesViewModel.cartList[index].price!.toString(),
                                                  style: TextStyle(fontSize: 12),),
                                              ),

                                              Container(
                                                child: Text(" X "+medicinesViewModel.cartList[index].qty!.toString()+" (qty)",
                                                  style: TextStyle(fontSize: 12),),
                                              ),

                                              Container(
                                                child: Text(" + Rs."+medicinesViewModel.cartList[index].tax!.toString()+" (tax)",
                                                  style: TextStyle(fontSize: 12),),
                                              ),

                                            ],
                                          ),

                                          Container(
                                            child: Text("= "+((medicinesViewModel.cartList[index].price! *
                                                medicinesViewModel.cartList[index].qty!)+
                                                medicinesViewModel.cartList[index].tax!).toString(),
                                              style: TextStyle(fontSize: 12),),
                                          ),

                                          SizedBox(height: 8,),

                                          Container(
                                              width:100,
                                              padding:EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(4),
                                                color: greenColor,
                                              ),
                                              child: Row(
                                                children: <Widget>[

                                                  InkWell(
                                                    onTap:(){
                                                      medicinesViewModel.removeUpdateCart(medicinesViewModel.cartList[index]);
                                                    },
                                                    child: Container(
                                                        decoration:BoxDecoration(
                                                            color: greenColor,
                                                            borderRadius: BorderRadius.circular(100)
                                                        ),
                                                        child: Icon(Icons.remove,size: 16,color: whiteColor,)),
                                                  ),

                                                  Expanded(
                                                    child: Container(
                                                      alignment:Alignment.center,
                                                        margin: EdgeInsets.only(left: 16,right: 16),
                                                        child: Text(medicinesViewModel.cartList[index].qty.toString(),
                                                          style: TextStyle(color: whiteColor),)
                                                    ),
                                                  ),

                                                  InkWell(
                                                    onTap: (){
                                                      medicinesViewModel.updateCart(medicinesViewModel.cartList[index]);
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
                                    ),

                                    InkWell(
                                      onTap:(){
                                        medicinesViewModel.removeFromCart(medicinesViewModel.cartList[index]);
                                      },
                                      child: Icon(Icons.delete_outline_sharp,
                                        color: redColor,),
                                    )

                                  ],
                                ),
                                Divider()

                              ],
                            );
                          }
                      ),
                    ),

                    if(medicinesViewModel.cartCount>0)
                      Positioned(
                        bottom: 8,
                        child: InkWell(
                          onTap: (){
                            //checkout
                          },
                          child: Card(
                            child: Container(
                              margin: EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[

                                  Container(
                                    margin: EdgeInsets.only(left: 8,right: 16),
                                    child: Text("Sub Total: Rs."+medicinesViewModel.subTotalprice.toString(),
                                    style: TextStyle(fontSize: 16),),
                                  ),

                                  Container(
                                    margin: EdgeInsets.only(left: 8,right: 16),
                                    child: Text("Other tax (GST): Rs."+((medicinesViewModel.subTotalprice*18)/100).toString(),
                                      style: TextStyle(fontSize: 16),),
                                  ),

                                  Divider(color: greenColor,height: 1,),

                                  Container(
                                    margin: EdgeInsets.only(left: 8,right: 16),
                                    child: Text("Grand Total: Rs."+(medicinesViewModel.subTotalprice+((medicinesViewModel.subTotalprice*18)/100)).toString(),
                                      style: TextStyle(fontSize: 20,
                                          fontWeight: FontWeight.bold),),
                                  ),

                                  InkWell(
                                    onTap: (){
                                      Get.to(AddressPage());
                                    },
                                    child: Card(
                                      elevation: 10,
                                      shape: BeveledRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)
                                      ),
                                      child: Container(
                                          padding: EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              color: greenColor
                                          ),
                                          child: Row(
                                            children: <Widget>[

                                              Text("Checkout",style: TextStyle(
                                                  fontSize: 20,color: Colors.white
                                              )),
                                              SizedBox(width: 8,),
                                              Icon(Icons.arrow_forward_ios_outlined,
                                                color: whiteColor,size: 20,)

                                            ],
                                          )
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          )
                        ),
                      )

                  ],
                ),
            ),
          floatingActionButton: Container(
            margin: EdgeInsets.only(bottom: 24),
            child: FloatingActionButton(
              backgroundColor: greenColor,
              onPressed: (){
                medicinesViewModel.clearCart();
              },
              child: Icon(Icons.clean_hands_outlined,color: whiteColor,),
            ),
          ),
        )
    );
  }
}