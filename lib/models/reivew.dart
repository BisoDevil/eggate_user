// To parse this JSON data, do
//
//     final review = reviewFromJson(jsonString);

import 'dart:convert';

class Review {
  int id;
  String title;
  String detail;
  String nickname;
  List<Rating> ratings;
  String reviewEntity;
  int reviewType;
  int reviewStatus;
  DateTime createdAt;
  int entityPkValue;
  int storeId;
  List<int> stores;

  Review({
    this.id,
    this.title,
    this.detail,
    this.nickname,
    this.ratings,
    this.reviewEntity,
    this.reviewType,
    this.reviewStatus,
    this.createdAt,
    this.entityPkValue,
    this.storeId,
    this.stores,
  });

  factory Review.fromJson(String str) => Review.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Review.fromMap(Map<String, dynamic> json) => Review(
        id: json["id"],
        title: json["title"],
        detail: json["detail"],
        nickname: json["nickname"],
        ratings:
            List<Rating>.from(json["ratings"].map((x) => Rating.fromMap(x))),
        reviewEntity: json["review_entity"],
        reviewType: json["review_type"],
        reviewStatus: json["review_status"],
        createdAt: DateTime.parse(json["created_at"]),
        entityPkValue: json["entity_pk_value"],
        storeId: json["store_id"],
        stores: List<int>.from(json["stores"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "detail": detail,
        "nickname": nickname,
        "ratings": List<dynamic>.from(ratings.map((x) => x.toMap())),
        "review_entity": reviewEntity,
        "review_type": reviewType,
        "review_status": reviewStatus,
        "created_at": createdAt.toIso8601String(),
        "entity_pk_value": entityPkValue,
        "store_id": storeId,
        "stores": List<dynamic>.from(stores.map((x) => x)),
      };
}

class Rating {
  int voteId;
  int ratingId;
  String ratingName;
  int percent;
  int value;

  Rating({
    this.voteId,
    this.ratingId,
    this.ratingName,
    this.percent,
    this.value,
  });

  factory Rating.fromJson(String str) => Rating.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Rating.fromMap(Map<String, dynamic> json) => Rating(
        voteId: json["vote_id"],
        ratingId: json["rating_id"],
        ratingName: json["rating_name"],
        percent: json["percent"],
        value: json["value"],
      );

  Map<String, dynamic> toMap() => {
        "vote_id": voteId,
        "rating_id": ratingId,
        "rating_name": ratingName,
        "percent": percent,
        "value": value,
      };
}
