// To parse this JSON data, do
//
//     final storeConfig = storeConfigFromJson(jsonString);

import 'dart:convert';

class StoreConfig {
  String baseCurrencyCode;
  dynamic baseCurrencySymbol;
  String defaultDisplayCurrencyCode;
  dynamic defaultDisplayCurrencySymbol;
  List<String> availableCurrencyCodes;
  List<ExchangeRate> exchangeRates;

  StoreConfig({
    this.baseCurrencyCode,
    this.baseCurrencySymbol,
    this.defaultDisplayCurrencyCode,
    this.defaultDisplayCurrencySymbol,
    this.availableCurrencyCodes,
    this.exchangeRates,
  });

  factory StoreConfig.fromJson(String str) =>
      StoreConfig.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory StoreConfig.fromMap(Map<String, dynamic> json) => StoreConfig(
        baseCurrencyCode: json["base_currency_code"],
        baseCurrencySymbol: json["base_currency_symbol"],
        defaultDisplayCurrencyCode: json["default_display_currency_code"],
        defaultDisplayCurrencySymbol: json["default_display_currency_symbol"],
        availableCurrencyCodes:
            List<String>.from(json["available_currency_codes"].map((x) => x)),
        exchangeRates: List<ExchangeRate>.from(
            json["exchange_rates"].map((x) => ExchangeRate.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "base_currency_code": baseCurrencyCode,
        "base_currency_symbol": baseCurrencySymbol,
        "default_display_currency_code": defaultDisplayCurrencyCode,
        "default_display_currency_symbol": defaultDisplayCurrencySymbol,
        "available_currency_codes":
            List<dynamic>.from(availableCurrencyCodes.map((x) => x)),
        "exchange_rates":
            List<dynamic>.from(exchangeRates.map((x) => x.toMap())),
      };
}

class ExchangeRate {
  String currencyTo;
  double rate;

  ExchangeRate({
    this.currencyTo,
    this.rate,
  });

  factory ExchangeRate.fromJson(String str) =>
      ExchangeRate.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ExchangeRate.fromMap(Map<String, dynamic> json) => ExchangeRate(
        currencyTo: json["currency_to"],
        rate: json["rate"].toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "currency_to": currencyTo,
        "rate": rate,
      };
}
