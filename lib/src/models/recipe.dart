import 'dart:convert';

import 'package:vila_tour_pmdm/src/models/models.dart';

class Recipe extends Article {
  bool approved;
  bool recent;
  List<Ingredient> ingredients;
  User creator;

  Recipe({
    required type,
    required id,
    required name,
    required description,
    required averageScore,
    required creationDate,
    required lastModificationDate,
    required reviews,
    required this.approved,
    required this.recent,
    required this.ingredients,
    required this.creator,
  }) : super(
            id: id,
            name: name,
            description: description,
            averageScore: averageScore,
            creationDate: creationDate,
            lastModificationDate: lastModificationDate,
            reviews: reviews,
            type: 'recipe');

  factory Recipe.fromJson(String str) => Recipe.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Recipe.fromMap(Map<String, dynamic> json) => Recipe(
        type: json["type"],
        id: json["id"],
        name: json["name"],
        description: json["description"],
        averageScore: json["averageScore"]?.toDouble(),
        creationDate: DateTime.parse(json["creationDate"]),
        lastModificationDate: DateTime.parse(json["lastModificationDate"]),
        reviews: List<dynamic>.from(json["reviews"].map((x) => x)),
        approved: json["approved"],
        recent: json["recent"],
        ingredients: List<Ingredient>.from(json["ingredients"].map((x) => x)),
        creator: User.fromMap(json["creator"]),
      );

  Map<String, dynamic> toMap() => {
        "type": type,
        "id": id,
        "name": name,
        "description": description,
        "averageScore": averageScore,
        "creationDate": creationDate.toIso8601String(),
        "lastModificationDate": lastModificationDate.toIso8601String(),
        "reviews": List<Review>.from(reviews.map((x) => x)),
        "approved": approved,
        "recent": recent,
        "ingredients": List<Ingredient>.from(ingredients.map((x) => x)),
        "creator": creator.toMap(),
      };

  static List<Recipe> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((item) => Recipe.fromMap(item)).toList();
  }
}
