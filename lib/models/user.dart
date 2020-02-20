// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

import 'package:localstorage/localstorage.dart';

class User {
  int id;
  int groupId;
  String defaultBilling;
  String defaultShipping;
  DateTime createdAt;
  DateTime updatedAt;
  String createdIn;

  String email;
  String firstname;
  String lastname;
  int gender;
  int storeId;
  int websiteId;
  List<Address> addresses;
  int disableAutoGroupChange;
  ExtensionAttributes extensionAttributes;

  User({
    this.id,
    this.groupId,
    this.defaultBilling,
    this.defaultShipping,
    this.createdAt,
    this.updatedAt,
    this.createdIn,
    this.email,
    this.firstname,
    this.lastname,
    this.gender,
    this.storeId,
    this.websiteId,
    this.addresses,
    this.disableAutoGroupChange,
    this.extensionAttributes,
  });

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"],
        groupId: json["group_id"],
        defaultBilling: json["default_billing"],
        defaultShipping: json["default_shipping"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        createdIn: json["created_in"],
        email: json["email"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        gender: json["gender"],
        storeId: json["store_id"],
        websiteId: json["website_id"],
        addresses: List<Address>.from(
            json["addresses"].map((x) => Address.fromMap(x))),
        disableAutoGroupChange: json["disable_auto_group_change"],
        extensionAttributes:
            ExtensionAttributes.fromMap(json["extension_attributes"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "group_id": groupId,
        "default_billing": defaultBilling,
        "default_shipping": defaultShipping,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "created_in": createdIn,
        "email": email,
        "firstname": firstname,
        "lastname": lastname,
        "gender": gender,
        "store_id": storeId,
        "website_id": websiteId,
        "addresses": List<dynamic>.from(addresses.map((x) => x.toMap())),
        "disable_auto_group_change": disableAutoGroupChange,
        "extension_attributes": extensionAttributes.toMap(),
      };
  void saveUserLocal(User user) async {
    final LocalStorage storage = new LocalStorage("eggate");
    try {
      final ready = await storage.ready;
      if (ready) {
        await storage.setItem("user", user.toJson());
        print("Basem Saved to local store");
      }
    } catch (err) {
      print(err);
    }
  }

  Future<User> getUserLocal() async {
    final LocalStorage storage = new LocalStorage("eggate");
    final ready = await storage.ready;

    final json = await storage.getItem("user");
    if (json == null) {
      return null;
    }
    return User.fromJson(json);
  }

  void logoutUser() async {
    final LocalStorage storage = new LocalStorage("eggate");
    final ready = await storage.ready;
    await storage.deleteItem("user");
  }
}

class Address {
  int id;
  int customerId;
  Region region;
  int regionId;
  String countryId;
  List<String> street;
  String telephone;
  String postcode;
  String city;
  String firstname;
  String lastname;
  bool defaultShipping;
  bool defaultBilling;

  Address({
    this.id,
    this.customerId,
    this.region,
    this.regionId,
    this.countryId,
    this.street,
    this.telephone,
    this.postcode,
    this.city,
    this.firstname,
    this.lastname,
    this.defaultShipping,
    this.defaultBilling,
  });

  factory Address.fromJson(String str) => Address.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Address.fromMap(Map<String, dynamic> json) => Address(
        id: json["id"],
        customerId: json["customer_id"],
        region: Region.fromMap(json["region"]),
        regionId: json["region_id"],
        countryId: json["country_id"],
        street: List<String>.from(json["street"].map((x) => x)),
        telephone: json["telephone"],
        postcode: json["postcode"],
        city: json["city"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        defaultShipping: json["default_shipping"],
        defaultBilling: json["default_billing"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "customer_id": customerId,
        "region": region.toMap(),
        "region_id": regionId,
        "country_id": countryId,
        "street": List<dynamic>.from(street.map((x) => x)),
        "telephone": telephone,
        "postcode": postcode,
        "city": city,
        "firstname": firstname,
        "lastname": lastname,
        "default_shipping": defaultShipping,
        "default_billing": defaultBilling,
      };
}

class Region {
  String regionCode;
  String region;
  int regionId;

  Region({
    this.regionCode,
    this.region,
    this.regionId,
  });

  factory Region.fromJson(String str) => Region.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Region.fromMap(Map<String, dynamic> json) => Region(
        regionCode: json["region_code"],
        region: json["region"],
        regionId: json["region_id"],
      );

  Map<String, dynamic> toMap() => {
        "region_code": regionCode,
        "region": region,
        "region_id": regionId,
      };
}

class ExtensionAttributes {
  bool isSubscribed;

  ExtensionAttributes({
    this.isSubscribed,
  });

  factory ExtensionAttributes.fromJson(String str) =>
      ExtensionAttributes.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ExtensionAttributes.fromMap(Map<String, dynamic> json) =>
      ExtensionAttributes(
        isSubscribed: json["is_subscribed"],
      );

  Map<String, dynamic> toMap() => {
        "is_subscribed": isSubscribed,
      };
}
