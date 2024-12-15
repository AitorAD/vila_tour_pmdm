import 'package:vila_tour_pmdm/src/models/models.dart';

class Ingredient {
  final int id;
  final String name;
  final CategoryIngredient category;

  Ingredient({
    required this.id,
    required this.name,
    required this.category,
  });

  // Crear un ingrediente a partir de un mapa
  factory Ingredient.fromMap(Map<String, dynamic> map) {
    return Ingredient(
      id: map['idIngredient'] ?? 0,
      name: map['name'] ?? 'Unknown',
      category: CategoryIngredient.fromMap(map['category'] ?? {}),
    );
  }

  // Método estático para crear una lista de ingredientes a partir de una lista de Map
  static List<Ingredient> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((item) => Ingredient.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  // Convertir un ingrediente a un mapa, asegurándose de que 'category' sea un mapa, no una cadena
  Map<String, dynamic> toMap() {
    return {
      "idIngredient": id,
      "name": name,
      "category": category.toMap(),  // Mantener 'category' como un objeto, no como una cadena
    };
  }

  @override
  String toString() {
    return name;
  }
}
