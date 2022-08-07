import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:user_app/model/CategoriesModel.dart';
import 'package:user_app/model/MedicineModel.dart';
import '../CustomClasses/ALL_COLORS.dart';
import '../CustomClasses/CustomToast.dart';
import '../CustomClasses/SingeltonClass.dart';

class CategoryViewModel extends GetxController{

  final CustomToast customToast = CustomToast();
  var dummyList = <CategoriesModel>[].obs;
  var categoryList = <CategoriesModel>[].obs;
  var categoryRelatedMedicinesdummyList = <MedicineModel>[].obs;
  var categoryRelatedMedicinesList = <MedicineModel>[].obs;
  var isCategoryLoading = true.obs;
  var isCategoryRelatedMedicinesLoading = true.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchAllCategories();
  }

  Future<void> fetchAllCategories() async{
    await FirebaseFirestore.instance.collection("categories")
        .orderBy('date',descending: true).get()
        .then((QuerySnapshot snapshot){
      for(var u in snapshot.docs){
        CategoriesModel categoriesModel = CategoriesModel(
          uid:u['uid'],
          description:u['description'],
          title:u['title'],
          catImage:u['catImage'],
          date:u['date'],
        );
        dummyList.add(categoriesModel);
      }
      if(dummyList != null){
        categoryList.value = dummyList;
        categoryList.shuffle();
        isCategoryLoading.value = false;
        SingeltonClass().myLogs(dummyList.toString());
      }
    }).catchError((error){
      SingeltonClass().myLogs(error);
      customToast.snackBarToast("Categories loading error!", error.toString(), whiteColor, redColor);
      isCategoryLoading.value = false;
    });
  }

  Future<void> fetchAllCategoryRelatedMedicines(String categoryId) async{
    await FirebaseFirestore.instance.collection("medicines")
        .orderBy('date',descending: true).get()
        .then((QuerySnapshot snapshot){
      for(var u in snapshot.docs){
        if(categoryId == u['category']){
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
          categoryRelatedMedicinesdummyList.add(medicineModel);
        }
      }
      if(categoryRelatedMedicinesList != null){
        categoryRelatedMedicinesList.addAll(categoryRelatedMedicinesdummyList);
        categoryRelatedMedicinesList.shuffle();
        isCategoryRelatedMedicinesLoading.value = false;
        SingeltonClass().myLogs(categoryRelatedMedicinesdummyList.toString());
      }
    }).catchError((error){
      customToast.snackBarToast("Medicines loading error!", error.toString(), whiteColor, redColor);
      isCategoryRelatedMedicinesLoading.value = false;
    });
  }

  void searchMedicines(String searchQuery){
    categoryRelatedMedicinesList.clear();
    categoryRelatedMedicinesdummyList.forEach((element) {
      if(element.title!.toLowerCase().contains(searchQuery)){
        categoryRelatedMedicinesList.add(element);
        SingeltonClass().myLogs(categoryRelatedMedicinesList.toString());
      }
    });
  }

}