class CategoriesModel{

  int? uid;
  String? title;
  String? description;
  String? catImage;
  String? date;

  CategoriesModel({this.uid,this.title,this.description,this.catImage,this.date});

  factory CategoriesModel.fromJson(Map<String, dynamic> json){
    return CategoriesModel(
      uid: json['uid'],
      title: json['title'],
      description: json['description'],
      catImage: json['catImage'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toMap(){
    return{
      'uid':uid,
      'title':title,
      'description':description,
      'catImage':catImage,
      'date':date,
    };
  }

}