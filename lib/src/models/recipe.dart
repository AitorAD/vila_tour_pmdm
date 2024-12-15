import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:vila_tour_pmdm/src/models/models.dart';

class Recipe extends Article {
  bool? approved;
  bool? recent;
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


  // Modificado para aceptar tanto un String como un Map<String, dynamic>
  factory Recipe.fromJson(dynamic source) {
    if (source is String) {
      return Recipe.fromMap(json.decode(source));
    } else if (source is Map<String, dynamic>) {
      return Recipe.fromMap(source);
    } else {
      throw ArgumentError('Invalid input type for Recipe.fromJson');
    }
  }

  String toJson() => json.encode(toMap());


  factory Recipe.fromMap(Map<String, dynamic> json) => Recipe(
        type: json["type"],
        id: json["id"],
        name: json["name"],
        description: json["description"],
        averageScore: json["averageScore"]?.toDouble(),
        creationDate: DateTime.parse(json["creationDate"]),
        lastModificationDate: DateTime.parse(json["lastModificationDate"]),
        reviews: json["reviews"] != null
            ? List<Review>.from(json["reviews"].map((x) => Review.fromMap(x)))
            : [],
        approved: json["approved"],
        recent: json["recent"],
        ingredients: json["ingredients"] != null
            ? List<Ingredient>.from(
                json["ingredients"].map((x) => Ingredient.fromMap(x)))
            : [],
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
        "reviews": reviews.map((x) => x.toMap()).toList(),
        "approved": approved,
        "recent": recent,
        "ingredients": ingredients.map((x) => x.toMap()).toList(),
        "creator": creator.toMap(),
      };

  static List<Recipe> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((item) => Recipe.fromMap(item)).toList();
  }
}
