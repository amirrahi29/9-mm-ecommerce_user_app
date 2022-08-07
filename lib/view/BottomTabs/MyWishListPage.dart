import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_app/CustomClasses/ALL_COLORS.dart';
import '../../CustomClasses/ALL_IMAGES.dart';
import '../../view_model/MedicineViewModel.dart';
import '../Drawer/LeftDrawer.dart';

class MyWishListPage extends StatefulWidget {
  const MyWishListPage({Key? key}) : super(key: key);

  @override
  _MyWishListPageState createState() => _MyWishListPageState();
}

class _MyWishListPageState extends State<MyWishListPage> {

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
                      child: medicinesViewModel.wishlistCount == 0?
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[

                          Icon(Icons.favorite_border,color: greenColor,
                            size: 84,),

                          Text("No items in wishlist",
                            style: TextStyle(fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: greenColor),),

                        ],
                      )
                          :ListView.builder(
                          itemCount: medicinesViewModel.wishList.length,
                          itemBuilder: (context,index){
                            return Column(
                              children: <Widget>[

                                Row(
                                  children: <Widget>[

                                    Container(
                                      height:50,
                                      width: 50,
                                      margin: EdgeInsets.all(8),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(100),
                                        child: CachedNetworkImage(
                                          imageUrl: medicinesViewModel.wishList[index].medicineImage!,
                                          placeholder: (context, url) => Center(
                                              child: CircularProgressIndicator()
                                          ),
                                          errorWidget: (context, url, error) => Icon(Icons.error),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[

                                          Container(
                                            child: Text(medicinesViewModel.wishList[index].title!,
                                              style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                          ),
                                          Container(
                                            child: Text(medicinesViewModel.wishList[index].description!,
                                              style: TextStyle(fontSize: 12),),
                                          ),

                                        ],
                                      ),
                                    ),

                                    InkWell(
                                      onTap:(){
                                        medicinesViewModel.toggleWishlist(medicinesViewModel.wishList[index]);
                                      },
                                      child: Icon(Icons.clear,
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

                    if(medicinesViewModel.wishlistCount>0)
                    Positioned(
                      bottom: 24,
                      child: InkWell(
                        onTap: (){
                          medicinesViewModel.shiftAllWishListToCart();
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

                                Text("Add to cart",style: TextStyle(
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
                    )

                  ],
                )),
          floatingActionButton: FloatingActionButton(
            backgroundColor: greenColor,
            onPressed: (){
              medicinesViewModel.clearWishlist();
            },
            child: Icon(Icons.clean_hands_outlined,color: whiteColor,),
          ),
        )
    );
  }
}