import 'package:vila_tour_pmdm/src/models/categoryIngredient.dart';

class Ingredient {
  final int id;
  final String name;
  final CategoryIngredient category;

  Ingredient({
    required this.id,
    required this.name,
    required this.category,
  });

  factory Ingredient.fromMap(Map<String, dynamic> map) {
    return Ingredient(
      id: map['idIngredient'] ?? 0,
      name: map['name'] ?? 'Unknown',
      category: CategoryIngredient.fromMap(map['categoryIngredient'] ?? {}),
    );
  }

  static List<Ingredient> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((item) => Ingredient.fromMap(item)).toList();
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "category": category,
      };

  @override
  String toString() {
    return name;
  }
}