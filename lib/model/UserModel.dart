class UserModel{

  String? name;
  String? email;
  String? password;
  String? dob;
  String? gender;
  String? image;
  String? accountCreated;

  UserModel({this.name,this.email,this.password,this.dob,this.gender,
  this.image,this.accountCreated});

  factory UserModel.fromJson(Map<String, dynamic> json){
    return UserModel(
      name: json['name'],
      email: json['email'],
      password: json['password'],
      dob: json['dob'],
      gender: json['gender'],
      image: json['image'],
      accountCreated: json['accountCreated'],
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'name':name,
      'email':email,
      'password':password,
      'dob':dob,
      'gender':gender,
      'image':image,
      'accountCreated':accountCreated,
    };
  }

}