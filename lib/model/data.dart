import 'dart:convert'

// MARK: - Welcome

import 'dart:ui';IdsData IdDatafromJson(String str) =>IdsData.fromJson(json.decode(str));
String IdDatafromJson(IdsData data) => json.encode(data.toJson());

class IdsData{
  IdsData({
    required this.page,
    required this.per_page,
    required this.total_pages,
    required this.data,
  });
  int page;
  int per_page;
  int total_pages;
  List<Id> data;

  factory IdsData.fromJson(Map<String, dynamic> json) => IdsData(
    page: json["page"],
    per_page: json["per_page"],
    total_pages: json["total_pages"]
    data: List<Id>.from(json["data"].map((x) => Id.fromJson(x) )),
   )

     Map<String, dynamic> toJson() => {
    "page": page,
    "per_page": per_page,
    "total_pages" : total_pages
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Id {
  Id({
    required this.email,
    required this.first_name,
    required this.last_name,
    required this.avatar,
    
  });

  String email;
  String first_name;
  String last_name;
  Image avatar;

   factory Id.fromJson(Map<String, dynamic> json) => Id(
    email: json["email"],
    first_name: json["first_name"],
    last_name: json["last_name"],
    avatar: json["avatar"]
  );

    Map<String, dynamic> toJson() => {
    "email": email,
    "first_name": first_name,
    "last_name": last_name,
    "avatar": avatar,
  };
}



