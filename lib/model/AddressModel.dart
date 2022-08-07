class AddressModel{

  String? uid;
  String? email;
  String? address;
  String? addressCreated;
  String? enabled;

  AddressModel({this.uid,this.email,this.address,this.addressCreated,this.enabled});

  factory AddressModel.fromJson(Map<String, dynamic> json){
    return AddressModel(
      uid: json['uid'],
      email: json['email'],
      address: json['address'],
      addressCreated: json['addressCreated'],
      enabled: json['enabled'],
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'uid':uid,
      'email':email,
      'address':address,
      'addressCreated':addressCreated,
      'enabled':enabled,
    };
  }

}