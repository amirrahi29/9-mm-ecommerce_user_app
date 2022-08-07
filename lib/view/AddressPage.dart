import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:user_app/CustomClasses/ALL_COLORS.dart';
import 'package:user_app/CustomClasses/PAYMENT_GATEWAYS.dart';
import 'package:user_app/view/PaymentStatus.dart';
import 'package:user_app/view_model/AddressViewModel.dart';
import 'package:user_app/view_model/MedicineViewModel.dart';
import '../CustomClasses/CustomToast.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({Key? key}) : super(key: key);

  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {

  static const platform = const MethodChannel("razorpay_flutter");
  late Razorpay _razorpay;

  final addressController = TextEditingController();
  final addressViewModel = Get.put(AddressViewModel());
  final medicinesViewModel = Get.put(MedicineViewModel());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    var options = {
      'key': razorpay_key,
      'amount': (medicinesViewModel.subTotalprice+((medicinesViewModel.subTotalprice*18)/100))*100,
      'name': 'Acme Corp.',
      'description': 'Fine T-Shirt',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Get.off(PaymentStatus(),
    arguments: [
      "1",
      response.paymentId
    ]);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Get.off(PaymentStatus(),
        arguments: [
          "0",
          response.code
        ]);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External SDK Response: ${response.walletName}');
    Get.off(PaymentStatus(),
        arguments: [
          "1",
          response.walletName
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: greenColor,
            title: Text("Manage addresses"),
          ),
          body: Obx(()=>LoadingOverlay(
            isLoading: addressViewModel.isProgressIndicatorAddress.value,
            child: Stack(
              children: <Widget>[

                Container(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      Row(
                        children: <Widget>[

                          Icon(Icons.add),
                          Text("Add address",
                            style: TextStyle(fontSize: 20,
                                fontWeight: FontWeight.bold),),

                        ],
                      ),

                      Divider(
                        color: greenColor,
                      ),

                      SizedBox(height: 16,),

                      TextField(
                        controller: addressController,
                        maxLines: 5,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16)
                          ),
                          labelText: 'Address',
                          hintText: 'Enter your address............',
                          alignLabelWithHint: true,
                        ),
                      ),

                      SizedBox(height: 16,),

                      InkWell(
                        onTap: (){
                          if(addressController.text != ""){
                            addressViewModel.addAddressFormSubmit(addressController.text);
                            addressController.text = "";
                          }
                          else{
                            CustomToast().snackBarToast("Address field is required!",
                                "Please fill address and try again!",
                                whiteColor, redColor);
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: greenColor,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Text("Submit",style: TextStyle(color: whiteColor,
                              fontSize: 20),),
                        ),
                      ),

                      SizedBox(height: 32,),

                      Container(
                          child: Row(
                            children: <Widget>[

                              Icon(Icons.list_alt),
                              Text("List of addresses",
                                style: TextStyle(fontSize: 20,
                                    fontWeight: FontWeight.bold),),

                            ],
                          )
                      ),

                      Divider(
                        color: greenColor,
                      ),

                      Expanded(
                          child: addressViewModel.isLoadingList.value == true?
                          Center(
                            child: CircularProgressIndicator(color: greenColor,),
                          ):ListView.builder(
                              itemCount: addressViewModel.addressList.length,
                              itemBuilder: (context,index){
                                return Obx(()=>addressViewModel.addressList.length<=0?
                                Center(
                                  child: Text("No addresses found!"),
                                ):InkWell(
                                  onTap: (){
                                    addressViewModel.onAddressSelected(addressViewModel.addressList[index].uid!.toString());
                                  },
                                  child: Card(
                                    child: Container(
                                        padding: EdgeInsets.all(16),
                                        child: Row(
                                          children: <Widget>[

                                            Container(
                                              height:16,
                                              width: 16,
                                              decoration: BoxDecoration(
                                                  color: addressViewModel.addressList[index].uid! !=
                                                      addressViewModel.isAddressSelected.value?
                                                  greyColor:greenColor,
                                                  borderRadius: BorderRadius.circular(100)
                                              ),
                                            ),

                                            SizedBox(width: 8,),

                                            Expanded(
                                              child: Container(
                                                child: Text(addressViewModel.addressList[index].address!),
                                              ),
                                            ),

                                            InkWell(
                                                onTap: (){
                                                  addressViewModel.deleteAddress(addressViewModel.addressList[index].uid!,
                                                      addressViewModel.addressList[index].address!,
                                                      addressViewModel.addressList[index].addressCreated!);
                                                },
                                                child: Icon(Icons.close, color:redColor,size: 20,))

                                          ],
                                        )
                                    ),
                                  ),
                                ));
                              }
                          )
                      )

                    ],
                  ),
                ),

                Positioned(
                  bottom: 0,
                    child: InkWell(
                      onTap: (){
                        if(addressViewModel.isAddressSelected.value == ""){
                          CustomToast().snackBarToast("Address is required!",
                              "Please select or add address to proceed!",
                              whiteColor, redColor);
                        }
                        else{
                          openCheckout();
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: greenColor,
                          borderRadius: BorderRadius.circular(0)
                        ),
                        child: Text("Checkout",
                        style: TextStyle(color: whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 24),),
                      ),
                    )
                )

              ],
            ),
          ))
        )
    );
  }
}
