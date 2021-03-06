// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

import 'package:eggate/services/magento.dart';

class Product {
  String domain = "https://eggate.shop/";
  int id;
  String sku;
  String name;
  int attributeSetId;
  num price;
  int status;
  int visibility;
  String typeId;

  num weight;
  ExtensionAttributes extensionAttributes;
  List<dynamic> productLinks;
  List<dynamic> options;
  List<MediaGalleryEntry> mediaGalleryEntries;
  List<dynamic> tierPrices;
  List<CustomAttribute> customAttributes;

  Product({
    this.id,
    this.sku,
    this.name,
    this.attributeSetId,
    this.price,
    this.status,
    this.visibility,
    this.typeId,
    this.weight,
    this.extensionAttributes,
    this.productLinks,
    this.options,
    this.mediaGalleryEntries,
    this.tierPrices,
    this.customAttributes,
  });

  factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());
  factory Product.fromMap(Map<String, dynamic> json) => Product(
        id: json["id"],
        sku: json["sku"],
        name: json["name"],
        attributeSetId: json["attribute_set_id"],
        price: json["price"] != null ? json["price"] * MagentoApi.rate : null,
        status: json["status"],
        visibility: json["visibility"],
        typeId: json["type_id"],
        weight: json["weight"],
        extensionAttributes:
            ExtensionAttributes.fromMap(json["extension_attributes"]),
        productLinks: List<dynamic>.from(json["product_links"].map((x) => x)),
        options: List<dynamic>.from(json["options"].map((x) => x)),
        mediaGalleryEntries: List<MediaGalleryEntry>.from(
            json["media_gallery_entries"]
                .map((x) => MediaGalleryEntry.fromMap(x))),
        tierPrices: List<dynamic>.from(json["tier_prices"].map((x) => x)),
        customAttributes: List<CustomAttribute>.from(
            json["custom_attributes"].map((x) => CustomAttribute.fromMap(x))),
      );
  Map<String, dynamic> toMap() => {
        "id": id,
        "sku": sku,
        "name": name,
        "attribute_set_id": attributeSetId,
        "price": price,
        "status": status,
        "visibility": visibility,
        "type_id": typeId,
        "weight": weight,
        "extension_attributes": extensionAttributes.toMap(),
        "product_links": List<dynamic>.from(productLinks.map((x) => x)),
        "options": List<dynamic>.from(options.map((x) => x)),
        "media_gallery_entries":
            List<dynamic>.from(mediaGalleryEntries.map((x) => x.toMap())),
        "tier_prices": List<dynamic>.from(tierPrices.map((x) => x)),
        "custom_attributes":
            List<dynamic>.from(customAttributes.map((x) => x.toMap())),
      };
}

class CustomAttribute {
  String attributeCode;
  dynamic value;

  CustomAttribute({
    this.attributeCode,
    this.value,
  });

  factory CustomAttribute.fromJson(String str) =>
      CustomAttribute.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CustomAttribute.fromMap(Map<String, dynamic> json) => CustomAttribute(
        attributeCode: json["attribute_code"],
        value: json["value"],
      );

  Map<String, dynamic> toMap() => {
        "attribute_code": attributeCode,
        "value": value,
      };
}

class ExtensionAttributes {
  num discountedPrice;
  num discountPercentage;
  String image;

  ExtensionAttributes(
      {this.discountedPrice, this.discountPercentage, this.image});

  factory ExtensionAttributes.fromJson(String str) =>
      ExtensionAttributes.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ExtensionAttributes.fromMap(
          Map<String, dynamic> json) =>
      ExtensionAttributes(
          discountedPrice: json["discounted_price"] != null
              ? json["discounted_price"] * MagentoApi.rate
              : null,
          discountPercentage: json["discount_percentage"] != null
              ? json["discount_percentage"] * MagentoApi.rate
              : null,
          image: json["image"]);

  Map<String, dynamic> toMap() => {
        "discounted_price": discountedPrice,
        "discount_percentage": discountPercentage,
        "image": image
      };
}

class MediaGalleryEntry {
  int id;
  String mediaType;
  String label;
  int position;
  bool disabled;
  List<String> types;
  String file;

  MediaGalleryEntry({
    this.id,
    this.mediaType,
    this.label,
    this.position,
    this.disabled,
    this.types,
    this.file,
  });

  factory MediaGalleryEntry.fromJson(String str) =>
      MediaGalleryEntry.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MediaGalleryEntry.fromMap(Map<String, dynamic> json) =>
      MediaGalleryEntry(
        id: json["id"],
        mediaType: json["media_type"],
        label: json["label"],
        position: json["position"],
        disabled: json["disabled"],
        types: List<String>.from(json["types"].map((x) => x)),
        file: "https://eggate.shop/pub/media/catalog/product${json["file"]}",
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "media_type": mediaType,
        "label": label,
        "position": position,
        "disabled": disabled,
        "types": List<dynamic>.from(types.map((x) => x)),
        "file": file,
      };
}
