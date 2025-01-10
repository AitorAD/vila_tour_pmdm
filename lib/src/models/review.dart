import 'dart:convert';

class Review {
  ReviewId id;
  int rating;
  String comment;
  DateTime postDate;
  bool? favorite;

  Review({
    required this.id,
    required this.rating,
    required this.comment,
    required this.postDate,
    this.favorite,
  });

  factory Review.fromJson(String str) => Review.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Review.fromMap(Map<String, dynamic> json) => Review(
        id: ReviewId.fromMap(json["id"]),
        rating: json["rating"],
        comment: json["comment"],
        postDate: DateTime.parse(json["postDate"]),
        favorite: json["favorite"],
      );

  Map<String, dynamic> toMap() => {
        // "id": id.toMap(),
        "rating": rating,
        "comment": comment,
        "postDate": postDate.toIso8601String(),
        "favorite": favorite,
      };
}

class ReviewId {
  int articleId;
  int userId;

  ReviewId({
    required this.articleId,
    required this.userId,
  });

  factory ReviewId.fromJson(String str) => ReviewId.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ReviewId.fromMap(Map<String, dynamic> json) => ReviewId(
        articleId: json["article_id"],
        userId: json["user_id"],
      );

  Map<String, dynamic> toMap() => {
        "article_id": articleId,
        "user_id": userId,
      };
}
