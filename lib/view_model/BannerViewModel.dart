import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:user_app/CustomClasses/ALL_COLORS.dart';
import 'package:user_app/CustomClasses/CustomToast.dart';
import 'package:user_app/model/BannersModel.dart';

import '../CustomClasses/SingeltonClass.dart';

class BannerViewModel extends GetxController{

  final CustomToast customToast = CustomToast();
  var dummyList = <BannersModel>[].obs;
  var bannerList = <BannersModel>[].obs;
  var isBannerLoading = true.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchAllBanners();
  }

  Future<void> fetchAllBanners() async{
    await FirebaseFirestore.instance.collection("banners")
        .orderBy('date',descending: true).get()
    .then((QuerySnapshot snapshot){
      for(var u in snapshot.docs){
        BannersModel bannersModel = BannersModel(
          uid:u['uid'],
          description:u['description'],
          title:u['title'],
          bannerImage:u['bannerImage'],
          date:u['date'],
        );
        dummyList.add(bannersModel);
      }
      if(dummyList != null){
        bannerList.value = dummyList;
        bannerList.shuffle();
        isBannerLoading.value = false;
        SingeltonClass().myLogs(dummyList.toString());
      }
    })
    .catchError((error){
      SingeltonClass().myLogs(error);
      customToast.snackBarToast("Banners loading error!", error.toString(), whiteColor, redColor);
      isBannerLoading.value = false;
    });
  }

}