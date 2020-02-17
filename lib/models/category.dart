// To parse this JSON data, do
//
//     final category = categoryFromJson(jsonString);

import 'dart:convert';

import 'package:eggate/services/magento.dart';

class Category {
  int id;
  int parentId;
  String name;
  String image;
  bool isActive;
  int position;
  int level;
  int productCount;
  List<Category> childrenData;

  Category({
    this.id,
    this.parentId,
    this.name,
    this.image,
    this.isActive,
    this.position,
    this.level,
    this.productCount,
    this.childrenData,
  });

  factory Category.fromJson(String str) => Category.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Category.fromMap(Map<String, dynamic> json) => Category(
        id: json["id"],
        parentId: json["parent_id"],
        name: json["name"],
        image: json["image"] == null
            ? null
            : "${MagentoApi().domain}pub/media/catalog/category/${json["image"]}",
        isActive: json["is_active"],
        position: json["position"],
        level: json["level"],
        productCount: json["product_count"],
        childrenData: List<Category>.from(
            json["children_data"].map((x) => Category.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "parent_id": parentId,
        "name": name,
        "image": image == null ? null : image,
        "is_active": isActive,
        "position": position,
        "level": level,
        "product_count": productCount,
        "children_data": List<dynamic>.from(childrenData.map((x) => x.toMap())),
      };
}
