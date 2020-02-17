// To parse this JSON data, do
//
//     final filters = filtersFromJson(jsonString);

import 'dart:convert';

class Filters {
  String code;
  String label;
  Type type;
  List<Value> values;

  Filters({
    this.code,
    this.label,
    this.type,
    this.values,
  });

  factory Filters.fromJson(String str) => Filters.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Filters.fromMap(Map<String, dynamic> json) => Filters(
        code: json["code"],
        label: json["label"],
        type: typeValues.map[json["type"]],
        values: List<Value>.from(json["values"].map((x) => Value.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "label": label,
        "type": typeValues.reverse[type],
        "values": List<dynamic>.from(values.map((x) => x.toMap())),
      };
}

enum Type { MULTISELECT, SELECT }

final typeValues =
    EnumValues({"multiselect": Type.MULTISELECT, "select": Type.SELECT});

class Value {
  String display;
  int value;
  int count;

  Value({this.display, this.value, this.count});

  factory Value.fromJson(String str) => Value.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Value.fromMap(Map<String, dynamic> json) => Value(
      display: json["display"], value: json["value"], count: json["count"]);

  Map<String, dynamic> toMap() =>
      {"display": display, "value": value, "count": count};
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
