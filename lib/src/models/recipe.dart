import 'dart:convert';

import 'package:vila_tour_pmdm/src/models/ingredient.dart';
import 'package:vila_tour_pmdm/src/models/models.dart';

class Recipe extends Article {
  bool approved;
  bool recent;
  List<dynamic> ingredients;

  Recipe({
    required int id,
    required String name,
    required String description,
    required String imagensPaths,
    required double averageScore,
    required DateTime creationDate,
    required DateTime lastModificationDate,
    required List<dynamic> reviews,
    required this.approved,
    required this.recent,
    required this.ingredients,
  }) : super(
          id: id,
          name: name,
          description: description,
          imagensPaths: imagensPaths,
          averageScore: averageScore,
          creationDate: creationDate,
          lastModificationDate: lastModificationDate,
          reviews: reviews,
        );

  factory Recipe.fromJson(String str) => Recipe.fromMap(json.decode(str));

  factory Recipe.fromMap(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      name: json['name'] ?? 'No name',
      description: json['description'] ?? 'No description available',
      imagensPaths: json["imagensPaths"] ?? 'https://res.cloudinary.com/heyset/image/upload/v1689582418/buukmenow-folder/no-image-icon-0.jpg',
      averageScore: json['averageScore'] ?? 0.0,
      // creationDate: DateTime.parse(map['creationDate']),
      // lastModificationDate: DateTime.parse(map['lastModificationDate']),
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
    );
  }

  // Método de fábrica para una lista de Festival
  static List<Recipe> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((item) => Recipe.fromMap(item)).toList();
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "description": description,
        "imagensPaths": imagensPaths,
        "averageScore": averageScore,
        "creationDate": creationDate.toIso8601String(),
        "lastModificationDate": lastModificationDate.toIso8601String(),
        "reviews": List<dynamic>.from(reviews.map((x) => x)),
        "coordinade": "coordinade",
        "approved": approved,
        "recent": recent,
        "ingredients": List<dynamic>.from(ingredients.map((x) => x.toMap())),
      };
}
