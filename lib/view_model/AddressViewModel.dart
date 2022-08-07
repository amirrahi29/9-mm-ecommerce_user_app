import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:user_app/model/AddressModel.dart';
import '../CustomClasses/ALL_COLORS.dart';
import '../CustomClasses/CustomToast.dart';
import '../CustomClasses/SingeltonClass.dart';

class AddressViewModel extends GetxController{

  var isProgressIndicatorAddress = false.obs;
  var isLoadingList = true.obs;
  var addressDummyList = <AddressModel>[].obs;
  var addressList = <AddressModel>[].obs;
  var isAddressSelected = "".obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchAllAddress();
  }

  onAddressSelected(String uid) async{
    isProgressIndicatorAddress.value = true;
    var userEmail =  await SingeltonClass().getUserEmail();
    if(userEmail != null){

      await FirebaseFirestore.instance.collection("addresses").get()
      .then((QuerySnapshot snapshot){
        for(var u in snapshot.docs){
          if(userEmail == u['email']){
            FirebaseFirestore.instance.collection("addresses")
                .doc(u['uid']).update({
              'enabled':'false'
            })
            .then((value){
              FirebaseFirestore.instance.collection("addresses")
                  .doc(uid).update({
                'enabled':'true'
              })
              .then((value){
                isProgressIndicatorAddress.value = false;
                isAddressSelected.value = uid;
              });
            });
          }
        }
      });
    }
  }

  fetchAllAddress() async{
    var userEmail =  await SingeltonClass().getUserEmail();
    addressDummyList.clear();
    addressList.clear();
    isLoadingList.value = true;
    await FirebaseFirestore.instance.collection("addresses")
        .orderBy('addressCreated',descending: true).get()
    .then((QuerySnapshot snapshot){
      for(var u in snapshot.docs){
        if(userEmail == u['email']){
          AddressModel addressModel = AddressModel(
            uid: u['uid'],
            email: u['email'],
            address: u['address'],
            addressCreated: u['addressCreated'],
            enabled: u['enabled'],
          );
          addressDummyList.add(addressModel);
        }
      }
      if(addressDummyList != null){
        addressList.value = addressDummyList;
        isLoadingList.value = false;
      }
    });
  }

  addAddressFormSubmit(String address) async{
    isProgressIndicatorAddress.value = true;
    var userEmail =  await SingeltonClass().getUserEmail();
    if(userEmail != null){
      int uniqueId = DateTime.now().microsecondsSinceEpoch;
      AddressModel addressModel = AddressModel(
        uid: uniqueId.toString(),
        email: userEmail,
        address: address,
        addressCreated: DateTime.now().toString(),
        enabled: "false",
      );
      await FirebaseFirestore.instance.collection("addresses")
      .doc(uniqueId.toString())
      .set(addressModel.toMap())
      .then((value){
        isProgressIndicatorAddress.value = false;
        CustomToast().snackBarToast("Congrats!",
            "One address successfully!",
            whiteColor, greenColor);
        SingeltonClass().myLogs("One address added successfully!");
        fetchAllAddress();
      }).catchError((error){
        SingeltonClass().myLogs(error);
        CustomToast().snackBarToast("Oops!, Something went wrong",
            error.toString(),
            whiteColor, redColor);
        isProgressIndicatorAddress.value = false;
      });
    }
  }

  deleteAddress(String uidd, String address, String created) async{
    isProgressIndicatorAddress.value = true;
    await FirebaseFirestore.instance.collection("addresses").doc(uidd).delete()
    .then((value){
      fetchAllAddress();
      isProgressIndicatorAddress.value = false;
      CustomToast().snackBarToast("Congrats!",
          "One address deleted successfully!",
          whiteColor, greenColor);
      SingeltonClass().myLogs(uidd);
    })
    .catchError((error){
      isProgressIndicatorAddress.value = false;
      SingeltonClass().myLogs(error);
      CustomToast().snackBarToast("Oops!, Something went wrong",
          error.toString(),
          whiteColor, redColor);
    });
  }

}