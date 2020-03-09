// To parse this JSON data, do
//
//     final orderModel = orderModelFromJson(jsonString);

import 'dart:convert';

import 'package:eggate/services/magento.dart';

class OrderModel {
  List<PaymentMethod> paymentMethods;
  Totals totals;

  OrderModel({
    this.paymentMethods,
    this.totals,
  });

  factory OrderModel.fromJson(String str) =>
      OrderModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OrderModel.fromMap(Map<String, dynamic> json) => OrderModel(
        paymentMethods: List<PaymentMethod>.from(
            json["payment_methods"].map((x) => PaymentMethod.fromMap(x))),
        totals: Totals.fromMap(json["totals"]),
      );

  Map<String, dynamic> toMap() => {
        "payment_methods":
            List<dynamic>.from(paymentMethods.map((x) => x.toMap())),
        "totals": totals.toMap(),
      };
}

class PaymentMethod {
  String code;
  String title;

  PaymentMethod({
    this.code,
    this.title,
  });

  factory PaymentMethod.fromJson(String str) =>
      PaymentMethod.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PaymentMethod.fromMap(Map<String, dynamic> json) => PaymentMethod(
        code: json["code"],
        title: json["title"],
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "title": title,
      };
}

class Totals {
  double grandTotal;
  double baseGrandTotal;
  double subtotal;
  double baseSubtotal;
  int discountAmount;
  int baseDiscountAmount;
  double subtotalWithDiscount;
  double baseSubtotalWithDiscount;
  double shippingAmount;
  double baseShippingAmount;
  int shippingDiscountAmount;
  int baseShippingDiscountAmount;
  int taxAmount;
  int baseTaxAmount;
  int shippingTaxAmount;
  int baseShippingTaxAmount;
  double subtotalInclTax;
  double shippingInclTax;
  double baseShippingInclTax;
  String baseCurrencyCode;
  String quoteCurrencyCode;
  int itemsQty;
  List<TotalSegment> totalSegments;

  Totals({
    this.grandTotal,
    this.baseGrandTotal,
    this.subtotal,
    this.baseSubtotal,
    this.discountAmount,
    this.baseDiscountAmount,
    this.subtotalWithDiscount,
    this.baseSubtotalWithDiscount,
    this.shippingAmount,
    this.baseShippingAmount,
    this.shippingDiscountAmount,
    this.baseShippingDiscountAmount,
    this.taxAmount,
    this.baseTaxAmount,
    this.shippingTaxAmount,
    this.baseShippingTaxAmount,
    this.subtotalInclTax,
    this.shippingInclTax,
    this.baseShippingInclTax,
    this.baseCurrencyCode,
    this.quoteCurrencyCode,
    this.itemsQty,
    this.totalSegments,
  });

  factory Totals.fromJson(String str) => Totals.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Totals.fromMap(Map<String, dynamic> json) => Totals(
    grandTotal: json["grand_total"].toDouble() * MagentoApi.rate,
        baseGrandTotal: json["base_grand_total"].toDouble(),
        subtotal: json["subtotal"].toDouble() * MagentoApi.rate,
        baseSubtotal: json["base_subtotal"].toDouble(),
        discountAmount: json["discount_amount"],
        baseDiscountAmount: json["base_discount_amount"],
        subtotalWithDiscount: json["subtotal_with_discount"].toDouble(),
        baseSubtotalWithDiscount:
            json["base_subtotal_with_discount"].toDouble(),
        shippingAmount: json["shipping_amount"].toDouble() * MagentoApi.rate,
        baseShippingAmount: json["base_shipping_amount"].toDouble(),
        shippingDiscountAmount: json["shipping_discount_amount"],
        baseShippingDiscountAmount: json["base_shipping_discount_amount"],
        taxAmount: json["tax_amount"],
        baseTaxAmount: json["base_tax_amount"],
        shippingTaxAmount: json["shipping_tax_amount"],
        baseShippingTaxAmount: json["base_shipping_tax_amount"],
        subtotalInclTax: json["subtotal_incl_tax"].toDouble(),
        shippingInclTax: json["shipping_incl_tax"].toDouble(),
        baseShippingInclTax: json["base_shipping_incl_tax"].toDouble(),
        baseCurrencyCode: json["base_currency_code"],
        quoteCurrencyCode: json["quote_currency_code"],
        itemsQty: json["items_qty"],
        totalSegments: List<TotalSegment>.from(
            json["total_segments"].map((x) => TotalSegment.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "grand_total": grandTotal,
        "base_grand_total": baseGrandTotal,
        "subtotal": subtotal,
        "base_subtotal": baseSubtotal,
        "discount_amount": discountAmount,
        "base_discount_amount": baseDiscountAmount,
        "subtotal_with_discount": subtotalWithDiscount,
        "base_subtotal_with_discount": baseSubtotalWithDiscount,
        "shipping_amount": shippingAmount,
        "base_shipping_amount": baseShippingAmount,
        "shipping_discount_amount": shippingDiscountAmount,
        "base_shipping_discount_amount": baseShippingDiscountAmount,
        "tax_amount": taxAmount,
        "base_tax_amount": baseTaxAmount,
        "shipping_tax_amount": shippingTaxAmount,
        "base_shipping_tax_amount": baseShippingTaxAmount,
        "subtotal_incl_tax": subtotalInclTax,
        "shipping_incl_tax": shippingInclTax,
        "base_shipping_incl_tax": baseShippingInclTax,
        "base_currency_code": baseCurrencyCode,
        "quote_currency_code": quoteCurrencyCode,
        "items_qty": itemsQty,
        "total_segments":
            List<dynamic>.from(totalSegments.map((x) => x.toMap())),
      };
}

class TotalSegment {
  String code;
  String title;
  double value;
  ExtensionAttributes extensionAttributes;
  String area;

  TotalSegment({
    this.code,
    this.title,
    this.value,
    this.extensionAttributes,
    this.area,
  });

  factory TotalSegment.fromJson(String str) =>
      TotalSegment.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TotalSegment.fromMap(Map<String, dynamic> json) => TotalSegment(
        code: json["code"],
        title: json["title"],
        value: json["value"].toDouble(),
        extensionAttributes: json["extension_attributes"] == null
            ? null
            : ExtensionAttributes.fromMap(json["extension_attributes"]),
        area: json["area"] == null ? null : json["area"],
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "title": title,
        "value": value,
        "extension_attributes":
            extensionAttributes == null ? null : extensionAttributes.toMap(),
        "area": area == null ? null : area,
      };
}

class ExtensionAttributes {
  List<dynamic> taxGrandtotalDetails;

  ExtensionAttributes({
    this.taxGrandtotalDetails,
  });

  factory ExtensionAttributes.fromJson(String str) =>
      ExtensionAttributes.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ExtensionAttributes.fromMap(Map<String, dynamic> json) =>
      ExtensionAttributes(
        taxGrandtotalDetails:
            List<dynamic>.from(json["tax_grandtotal_details"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "tax_grandtotal_details":
            List<dynamic>.from(taxGrandtotalDetails.map((x) => x)),
      };
}
