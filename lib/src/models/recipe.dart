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
    required dynamic imagensPaths,
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

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'] ?? 0,
      name: map['name'] ?? 'No name',
      description: map['description'] ?? 'No description available',
      imagensPaths: map['imagensPaths'] ??
          'https://www.cams-it.com/wp-content/uploads/2015/05/default-placeholder-300x200.png',
      averageScore: map['averageScore'] ?? 0.0,
      creationDate: DateTime.parse(map['creationDate']),
      lastModificationDate: DateTime.parse(map['lastModificationDate']),
      reviews: List<dynamic>.from(map['reviews'] ?? []),
      approved: map['approved'] ?? false,
      recent: map['recent'] ?? false,
      ingredients: (map['ingredients'] as List<dynamic>? ?? [])
          .where((ingredient) => ingredient is Map<String, dynamic>)
          .map((ingredientMap) =>
              Ingredient.fromMap(ingredientMap as Map<String, dynamic>))
          .toList(),
    );
  }
}
