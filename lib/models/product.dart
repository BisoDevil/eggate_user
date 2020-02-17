// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

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
  DateTime createdAt;
  DateTime updatedAt;
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
    this.createdAt,
    this.updatedAt,
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
        price: json["price"],
        status: json["status"],
        visibility: json["visibility"],
        typeId: json["type_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
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
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
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
  List<int> websiteIds;
  List<CategoryLink> categoryLinks;
  num discountedPrice;
  num discountPercentage;

  ExtensionAttributes(
      {this.websiteIds,
      this.categoryLinks,
      this.discountedPrice,
      this.discountPercentage});

  factory ExtensionAttributes.fromJson(String str) =>
      ExtensionAttributes.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ExtensionAttributes.fromMap(Map<String, dynamic> json) =>
      ExtensionAttributes(
          websiteIds: List<int>.from(json["website_ids"].map((x) => x)),
          categoryLinks: List<CategoryLink>.from(
              json["category_links"].map((x) => CategoryLink.fromMap(x))),
          discountedPrice: json["discounted_price"],
          discountPercentage: json["discount_percentage"]);

  Map<String, dynamic> toMap() => {
        "website_ids": List<dynamic>.from(websiteIds.map((x) => x)),
        "category_links":
            List<dynamic>.from(categoryLinks.map((x) => x.toMap())),
        "discounted_price": discountedPrice,
        "discount_percentage": discountPercentage
      };
}

class CategoryLink {
  int position;
  String categoryId;

  CategoryLink({
    this.position,
    this.categoryId,
  });

  factory CategoryLink.fromJson(String str) =>
      CategoryLink.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CategoryLink.fromMap(Map<String, dynamic> json) => CategoryLink(
        position: json["position"],
        categoryId: json["category_id"],
      );

  Map<String, dynamic> toMap() => {
        "position": position,
        "category_id": categoryId,
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
