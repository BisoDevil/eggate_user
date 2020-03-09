// To parse this JSON data, do
//
//     final cart = cartFromJson(jsonString);

import 'dart:convert';

import 'package:eggate/services/magento.dart';

class Cart {
  int itemId;
  String sku;
  int qty;
  String name;
  double price;
  String productType;
  String quoteId;
  ExtensionAttributes extensionAttributes;

  Cart({
    this.itemId,
    this.sku,
    this.qty,
    this.name,
    this.price,
    this.productType,
    this.quoteId,
    this.extensionAttributes,
  });

  factory Cart.fromJson(String str) => Cart.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Cart.fromMap(Map<String, dynamic> json) => Cart(
    itemId: json["item_id"],
        sku: json["sku"],
        qty: json["qty"],
        name: json["name"],
        price: json["price"] * MagentoApi.rate,
        productType: json["product_type"],
        quoteId: json["quote_id"],
        extensionAttributes:
            ExtensionAttributes.fromMap(json["extension_attributes"]),
      );

  Map<String, dynamic> toMap() => {
        "item_id": itemId,
        "sku": sku,
        "qty": qty,
        "name": name,
        "price": price,
        "product_type": productType,
        "quote_id": quoteId,
        "extension_attributes": extensionAttributes.toMap(),
      };
}

class ExtensionAttributes {
  String image;

  ExtensionAttributes({
    this.image,
  });

  factory ExtensionAttributes.fromJson(String str) =>
      ExtensionAttributes.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ExtensionAttributes.fromMap(Map<String, dynamic> json) =>
      ExtensionAttributes(
        image: json["image"],
      );

  Map<String, dynamic> toMap() => {
        "image": image,
      };
}
