import 'dart:convert';

import 'package:vila_tour_pmdm/src/models/models.dart';

class Recipe extends Article {
  bool approved;
  bool recent;
  List<Ingredient> ingredients;

  Recipe({
    required int id,
    required String name,
    required String description,
    required List<String> imagensPaths,
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

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'] ?? 0,
      name: map['name'] ?? 'No name',
      description: map['description'] ?? 'No description available',
      imagensPaths: List<String>.from(
        map['imagensPaths'] ?? [
          'https://www.cams-it.com/wp-content/uploads/2015/05/default-placeholder-300x200.png'
        ],
      ),
      averageScore: map['averageScore'] ?? 0.0,
      creationDate: map['creationDate'] is String
          ? DateTime.tryParse(map['creationDate']) ?? DateTime.now()
          : DateTime.now(),
      lastModificationDate: map['lastModificationDate'] is String
          ? DateTime.tryParse(map['lastModificationDate']) ?? DateTime.now()
          : DateTime.now(),
      reviews: List<dynamic>.from(map['reviews'] ?? []),
      approved: map['approved'] ?? false,
      recent: map['recent'] ?? false,
      ingredients: map['ingredients'] != null
          ? (map['ingredients'] as List)
              .map((item) => Ingredient.fromMap(item as Map<String, dynamic>))
              .toList()
          : [],
    );
  }

  static List<Recipe> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((item) => Recipe.fromMap(item)).toList();
  }
}
