// To parse this JSON data, do
//
//     final shippingMethod = shippingMethodFromJson(jsonString);

import 'dart:convert';

class ShippingMethod {
  String carrierCode;
  String methodCode;
  String carrierTitle;
  String methodTitle;
  double amount;
  double baseAmount;
  bool available;
  String errorMessage;
  double priceExclTax;
  double priceInclTax;

  ShippingMethod({
    this.carrierCode,
    this.methodCode,
    this.carrierTitle,
    this.methodTitle,
    this.amount,
    this.baseAmount,
    this.available,
    this.errorMessage,
    this.priceExclTax,
    this.priceInclTax,
  });

  factory ShippingMethod.fromJson(String str) =>
      ShippingMethod.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ShippingMethod.fromMap(Map<String, dynamic> json) => ShippingMethod(
        carrierCode: json["carrier_code"],
        methodCode: json["method_code"],
        carrierTitle: json["carrier_title"],
        methodTitle: json["method_title"],
        amount: json["amount"].toDouble(),
        baseAmount: json["base_amount"].toDouble(),
        available: json["available"],
        errorMessage: json["error_message"],
        priceExclTax: json["price_excl_tax"].toDouble(),
        priceInclTax: json["price_incl_tax"].toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "carrier_code": carrierCode,
        "method_code": methodCode,
        "carrier_title": carrierTitle,
        "method_title": methodTitle,
        "amount": amount,
        "base_amount": baseAmount,
        "available": available,
        "error_message": errorMessage,
        "price_excl_tax": priceExclTax,
        "price_incl_tax": priceInclTax,
      };
}
