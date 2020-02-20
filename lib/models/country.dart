// To parse this JSON data, do
//
//     final country = countryFromJson(jsonString);

import 'dart:convert';

class Country {
  String id;
  String twoLetterAbbreviation;
  String threeLetterAbbreviation;
  String fullNameLocale;
  String fullNameEnglish;
  List<AvailableRegion> availableRegions;

  Country({
    this.id,
    this.twoLetterAbbreviation,
    this.threeLetterAbbreviation,
    this.fullNameLocale,
    this.fullNameEnglish,
    this.availableRegions,
  });

  factory Country.fromJson(String str) => Country.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Country.fromMap(Map<String, dynamic> json) => Country(
        id: json["id"],
        twoLetterAbbreviation: json["two_letter_abbreviation"],
        threeLetterAbbreviation: json["three_letter_abbreviation"],
        fullNameLocale:
            json["full_name_locale"] == null ? null : json["full_name_locale"],
        fullNameEnglish: json["full_name_english"] == null
            ? null
            : json["full_name_english"],
        availableRegions: json["available_regions"] == null
            ? null
            : List<AvailableRegion>.from(json["available_regions"]
                .map((x) => AvailableRegion.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "two_letter_abbreviation": twoLetterAbbreviation,
        "three_letter_abbreviation": threeLetterAbbreviation,
        "full_name_locale": fullNameLocale == null ? null : fullNameLocale,
        "full_name_english": fullNameEnglish == null ? null : fullNameEnglish,
        "available_regions": availableRegions == null
            ? null
            : List<dynamic>.from(availableRegions.map((x) => x.toMap())),
      };
}

class AvailableRegion {
  String id;
  String code;
  String name;

  AvailableRegion({
    this.id,
    this.code,
    this.name,
  });

  factory AvailableRegion.fromJson(String str) =>
      AvailableRegion.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AvailableRegion.fromMap(Map<String, dynamic> json) => AvailableRegion(
        id: json["id"],
        code: json["code"],
        name: json["name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "code": code,
        "name": name,
      };
}
