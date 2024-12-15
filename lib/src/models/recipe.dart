import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:vila_tour_pmdm/src/models/models.dart';

class Recipe extends Article {
  bool? approved;
  bool? recent;
  List<Ingredient> ingredients;
  User creator;

  Recipe({
    required int id,
    required String name,
    required String description,
    required double averageScore,
    required DateTime creationDate,
    required DateTime lastModificationDate,
    required List<dynamic> reviews,
    required this.creator,
    required this.approved,
    required this.recent,
    required this.ingredients,
    required String type,
  }) : super(
          id: id,
          name: name,
          description: description,
          averageScore: averageScore,
          creationDate: creationDate,
          lastModificationDate: lastModificationDate,
          reviews: reviews,
          type: type,
        );

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

  factory Recipe.fromMap(Map<String, dynamic> json) {
    return Recipe(
      type: json['type'],
      id: json['id'],
      name: json['name'] ?? 'No name',
      description: json['description'] ?? 'No description available',
      averageScore: json['averageScore'] ?? 0.0,
      creationDate: json['creationDate'] is String
          ? DateTime.tryParse(json['creationDate']) ?? DateTime.now()
          : DateTime.now(),
      lastModificationDate: json['lastModificationDate'] is String
          ? DateTime.tryParse(json['lastModificationDate']) ?? DateTime.now()
          : DateTime.now(),
      reviews: List<dynamic>.from(json['reviews'] ?? []),
      approved: json['approved'] ?? false,
      recent: json['recent'] ?? false,
      ingredients: (json['ingredients'] as List<dynamic>? ?? [])
          .where((ingredient) => ingredient is Map<String, dynamic>)
          .map((ingredientMap) =>
              Ingredient.fromMap(ingredientMap as Map<String, dynamic>))
          .toList(),
      creator: User.fromMap(json['creator'] as Map<String, dynamic>),
    );
  }

  static List<Recipe> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((item) => Recipe.fromMap(item)).toList();
  }

  Map<String, dynamic> toMap() => {
        "type": type,
        "name": name,
        "description": description,
        "averageScore": averageScore,
        "creationDate": formatDate(creationDate),
        "lastModificationDate": formatDate(lastModificationDate),
        "reviews": List<dynamic>.from(reviews.map((x) => x)),
        "approved": approved,
        "recent": recent,
        "ingredients": List<dynamic>.from(ingredients.map((x) => x.toMap())),
        "creator": creator.toMapMinimal(),
      };

  String toJson() => json.encode(toMap());

  String formatDate(DateTime date) {
    return DateFormat("yyyy-MM-ddTHH:mm:ss").format(date);
  }
}
