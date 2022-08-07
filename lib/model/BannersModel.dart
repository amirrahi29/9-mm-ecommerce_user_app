class BannersModel{

  int? uid;
  String? description;
  String? title;
  String? bannerImage;
  String? date;

  BannersModel({this.uid,this.description,this.title,this.bannerImage,this.date});

  factory BannersModel.fromJson(Map<String, dynamic> json){
    return BannersModel(
      uid: json['uid'],
      description: json['description'],
      title: json['title'],
      bannerImage: json['bannerImage'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toMap(){
    return {
      "uid":uid,
      "description":description,
      "title":title,
      "bannerImage":bannerImage,
      "date":date,
    };
  }

}