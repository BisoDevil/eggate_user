// To parse this JSON data, do
//
//     final homePageStyle = homePageStyleFromJson(jsonString);

import 'dart:convert';

import 'package:eggate/services/magento.dart';

class HomePageStyle {
  List<HomeBaner> slider;
  List<HomeBaner> banner;
  List<CategoryList> categoryList;

  HomePageStyle({
    this.slider,
    this.banner,
    this.categoryList,
  });

  factory HomePageStyle.fromJson(String str) =>
      HomePageStyle.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory HomePageStyle.fromMap(Map<String, dynamic> json) => HomePageStyle(
        slider: List<HomeBaner>.from(
            json["slider"].map((x) => HomeBaner.fromMap(x))),
        banner: List<HomeBaner>.from(
            json["banner"].map((x) => HomeBaner.fromMap(x))),
        categoryList: List<CategoryList>.from(
            json["categoryList"].map((x) => CategoryList.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "slider": List<dynamic>.from(slider.map((x) => x.toMap())),
        "banner": List<dynamic>.from(banner.map((x) => x.toMap())),
        "categoryList": List<dynamic>.from(categoryList.map((x) => x.toMap())),
      };
}

class HomeBaner {
  String type;
  int id;
  String image;

  HomeBaner({
    this.type,
    this.id,
    this.image,
  });

  factory HomeBaner.fromJson(String str) => HomeBaner.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory HomeBaner.fromMap(Map<String, dynamic> json) => HomeBaner(
        type: json["type"],
        id: json["id"],
        image: json["image"].toString().contains("http")
            ? json["image"]
            : "${MagentoApi().domain}pub/media/${json["image"]}",
      );

  Map<String, dynamic> toMap() => {
        "type": type,
        "id": id,
        "image": image,
      };
}

class CategoryList {
  int id;
  String name;

  CategoryList({
    this.id,
    this.name,
  });

  factory CategoryList.fromJson(String str) =>
      CategoryList.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CategoryList.fromMap(Map<String, dynamic> json) => CategoryList(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
      };
}
