import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:user_app/model/MedicineModel.dart';
import 'package:user_app/model/OrderModel.dart';
import '../CustomClasses/ALL_COLORS.dart';
import '../CustomClasses/CustomToast.dart';
import '../CustomClasses/SingeltonClass.dart';

class MedicineViewModel extends GetxController{

  final CustomToast customToast = CustomToast();
  var dummyList = <MedicineModel>[].obs;
  var medicineList = <MedicineModel>[].obs;
  var medicineOrderList = <OrderModel>[].obs;
  var medicineOrderProductList = <MedicineModel>[].obs;
  var searchMedicineList = <MedicineModel>[].obs;
  var cartList = <MedicineModel>[].obs;
  var wishList = <MedicineModel>[].obs;
  var isMedicineLoading = true.obs;
  var isorderLoading = true.obs;
  var isorderDetailsLoading = true.obs;
  var categoryName = "".obs;

  int get cartCount => cartList.length;
  int get ordersCount => medicineOrderList.length;
  int get wishlistCount => wishList.length;
  double get price => cartList.fold(0, (previousValue, element) => previousValue+element.price!);
  double get subTotalprice => cartList.fold(0, (previousValue, element) => previousValue+element.price!*element.qty!+element.tax!);

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchAllMedicines();
  }

  Future<void> fetchAllMedicines() async{
    await FirebaseFirestore.instance.collection("medicines").get()
        .then((QuerySnapshot snapshot){
      for(var u in snapshot.docs){
        MedicineModel medicineModel = MedicineModel(
          uid:u['uid'],
          title:u['title'],
          description:u['description'],
          category:u['category'],
          date:u['date'],
          medicineImage:u['medicineImage'],
          tax:u['tax'],
          price:u['price'],
          qty:1,
        );
        dummyList.add(medicineModel);
      }
      if(dummyList != null){
        medicineList.value = dummyList;
        searchMedicineList.addAll(dummyList);
        medicineList.shuffle();
        searchMedicineList.shuffle();
        isMedicineLoading.value = false;
        SingeltonClass().myLogs(dummyList.toString());
      }
    }).catchError((error){
      customToast.snackBarToast("Medicines loading error!", error.toString(), whiteColor, redColor);
      isMedicineLoading.value = false;
      SingeltonClass().myLogs(error);
    });
  }

  Future<void> getProductCategory(MedicineModel medicineModel) async{
    await FirebaseFirestore.instance.collection("categories").get()
        .then((QuerySnapshot querySnapshot){
      for(var u in querySnapshot.docs){
        if(medicineModel.category == u['uid'].toString())
        {
          categoryName.value = u['title'];
        }
      }
    });
  }

  //cart section start
  addToCart(MedicineModel medicineModel){
    cartList.add(medicineModel);
    SingeltonClass().myLogs("product added into cart");
  }

  updateCart(MedicineModel medicineModel){
    int index = cartList.indexWhere((element) => element.uid == medicineModel.uid);
    if(cartList[index].qty! >= 1){
      cartList[index].qty = cartList[index].qty!+1;
      cartList.refresh();
      SingeltonClass().myLogs("quantity updated");
    }
    else{
      cartList.remove(medicineModel);
      cartList.refresh();
      SingeltonClass().myLogs("product removed from cart");
    }
  }

  removeUpdateCart(MedicineModel medicineModel){
    int index = cartList.indexWhere((element) => element.uid == medicineModel.uid);
    if(cartList[index].qty! > 1){
      cartList[index].qty = cartList[index].qty!-1;
      cartList.refresh();
      SingeltonClass().myLogs("quantity updated in cart");
    }
    else{
      cartList.remove(medicineModel);
      cartList.refresh();
      SingeltonClass().myLogs("product removed from cart");
    }
  }

  removeFromCart(MedicineModel medicineModel){
    cartList.removeWhere((element) => element.uid == medicineModel.uid);
    SingeltonClass().myLogs("product removed from cart");
  }

  clearCart(){
    cartList.clear();
    customToast.snackBarToast('Congrats!', "all cart items cleared successfully", whiteColor, greenColor);
    SingeltonClass().myLogs("cart cleared");
  }
  //cart section end

  //wishlist section start
  toggleWishlist(MedicineModel medicineModel){
      if(!wishList.contains(medicineModel)) {
        if(cartList.contains(medicineModel)){
          customToast.snackBarToast(medicineModel.title!, "Already added into wishlist", whiteColor, redColor);
        }
        else{
          wishList.add(medicineModel);
          SingeltonClass().myLogs("product added from wishlist");
          //customToast.snackBarToast(medicineModel.title!, "Added into wishlist", whiteColor, greenColor);
        }
      } else {
        wishList.remove(medicineModel);
        SingeltonClass().myLogs("product removed from wishlist");
        //customToast.snackBarToast(medicineModel.title!, "Removed from wishlist", whiteColor, redColor);
      }
    }
  shiftAllWishListToCart(){
      cartList.addAll(wishList);
      clearWishlist();
      SingeltonClass().myLogs("all products shifted from wishlist to cart");
  }
  clearWishlist(){
      wishList.clear();
      customToast.snackBarToast('Congrats!', "all wishlist items cleared successfully", whiteColor, greenColor);
      SingeltonClass().myLogs("wishlist cleared");
  }
  //whishlist section end

  searchMedicines(String searchQuery){
    searchMedicineList.clear();
    medicineList.forEach((element) {
      if(element.title!.toLowerCase().contains(searchQuery)){
        searchMedicineList.add(element);
        SingeltonClass().myLogs(searchMedicineList.toString());
      }
    });
  }

  submitOrders(String orderId, String status) async{
    var userEmail =  await SingeltonClass().getUserEmail();
    if(userEmail != null){
      await FirebaseFirestore.instance.collection("orders").doc("orderId$orderId")
          .set({
           'orderId': "orderId$orderId",
           'totalPrice': (subTotalprice+((subTotalprice*18)/100)).toString(),
           'email': userEmail,
           'status': status,
           'dateCreated': DateTime.now().toString()
          });
      for(var u in cartList){
        await FirebaseFirestore.instance.collection("orders")
        .doc("orderId$orderId").collection("medicines").add({
          'medicineId':u.uid.toString(),
          'qty':u.qty.toString(),
        });
      }
      SingeltonClass().myLogs("one order added.");
    }
  }

  getAllMedicinesOrders() async{
    isorderLoading.value = true;
    var userEmail =  await SingeltonClass().getUserEmail();
    if(userEmail != null){
      medicineOrderList.clear();
      await FirebaseFirestore.instance.collection("orders")
          .orderBy('dateCreated',descending: true).get()
      .then((QuerySnapshot snapshot){
        for(var u in snapshot.docs){
          if(u['email'] == userEmail)
          medicineOrderList.add(OrderModel(
            orderId: u['orderId'],
            totalPrice: u['totalPrice'],
            dateCreated: u['dateCreated'],
            email: u['email'],
            status: u['status'],
          ));
        }
        isorderLoading.value = false;
      });
    }
  }

  getAllOrderProducts(String orderId) async{
    isorderDetailsLoading.value = true;
    await FirebaseFirestore.instance.collection("orders")
    .doc(orderId).collection("medicines").get()
        .then((QuerySnapshot snapshot){
         medicineOrderProductList.clear();
          for(var u in snapshot.docs){
            FirebaseFirestore.instance.collection("medicines")
            .doc(u['medicineId']).get()
            .then((value) {
              medicineOrderProductList.add(MedicineModel(
                uid: value.data()!['uid'],
                title: value.data()!['title'],
                description: value.data()!['description'],
                category: value.data()!['category'],
                date: value.data()!['date'],
                medicineImage: value.data()!['medicineImage'],
                price: value.data()!['price'],
                tax: value.data()!['tax'],
                qty: value.data()!['qty'],
              ));
            });
          }
         isorderDetailsLoading.value = false;
        });
  }

}