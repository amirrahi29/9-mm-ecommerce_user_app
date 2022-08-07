class MedicineModel{

  int? uid;
  String? title;
  String? description;
  String? category;
  String? date;
  String? medicineImage;
  double? tax;
  double? price;
  int? qty = 1;

  MedicineModel({this.uid,this.title,this.description,this.category,
    this.date,this.medicineImage,this.tax,this.price,this.qty});

  factory MedicineModel.fromJson(Map<String, dynamic> json){
   return MedicineModel(
     uid: json['uid'],
     title: json['title'],
     description: json['description'],
     category: json['category'],
     date: json['date'],
     medicineImage: json['medicineImage'],
     tax: json['tax'].toDouble(),
     price: json['price'].toDouble(),
     qty: json['qty'],
   );
  }

  Map<String, dynamic> toMap(){
    return{
      'uid':uid,
      'title':title,
      'description':description,
      'category':category,
      'date':date,
      'medicineImage':medicineImage,
      'tax':tax,
      'price':price,
      'qty':qty,
    };
  }

}