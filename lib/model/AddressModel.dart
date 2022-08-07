class AddressModel{

  String? uid;
  String? email;
  String? address;
  String? addressCreated;

  AddressModel({this.uid,this.email,this.address,this.addressCreated});

  factory AddressModel.fromJson(Map<String, dynamic> json){
    return AddressModel(
      uid: json['uid'],
      email: json['email'],
      address: json['address'],
      addressCreated: json['addressCreated'],
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'uid':uid,
      'email':email,
      'address':address,
      'addressCreated':addressCreated,
    };
  }

}