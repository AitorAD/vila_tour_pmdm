import 'package:vila_tour_pmdm/src/models/ingredient.dart';
import 'package:vila_tour_pmdm/src/models/models.dart';

class Recipe extends Article {
  String location;
  String date;
  bool approved;
  List<Ingredient> ingredients;


  Recipe({
    required int id,
    required String name,
    required String description,
    required String imagePath,
    required double averageScore,
    required bool favourite,
    required this.ingredients,
    required this.approved,
    required this.location,
    required this.date,
  }) : super(
          id: id,
          name: name,
          description: description,
          imagePath: imagePath,
          averageScore: averageScore,
          favourite: favourite,
        );

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'] ?? 0,
      name: map['name'] ?? 'No name',
      description: map['description'] ?? 'No description available',
      imagePath: map['imagePath'] ?? 'https://www.cams-it.com/wp-content/uploads/2015/05/default-placeholder-300x200.png',
      averageScore: map['averageScore'] ?? 0.0,
      favourite: map['favourite'] ?? false,
      location: map['location'] ?? 'Unknown location',
      date: map['date'] ?? 'No date',
      approved: map['approved'] ?? false,
      ingredients: map['ingredients'] ?? [],
    );
  }
}
