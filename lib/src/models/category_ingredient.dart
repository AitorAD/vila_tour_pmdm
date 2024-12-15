import 'dart:convert';

class CategoryIngredient {
  final int id;
  final String name;

  CategoryIngredient({
    required this.id,
    required this.name,
  });

  // Constructor para crear una instancia desde un Map
  factory CategoryIngredient.fromMap(Map<String, dynamic> map) {
    return CategoryIngredient(
      id: map['id'] ?? 0, // Si 'id' no está presente, se asigna 0
      name: map['name'] ?? 'Unknown', // Si 'name' no está presente, se asigna 'Unknown'
    );
  }

  // Constructor para crear una instancia desde un JSON string
  factory CategoryIngredient.fromJson(String source) =>
      CategoryIngredient.fromMap(json.decode(source));

  // Método para convertir la instancia a un Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  String toJson() => json.encode(toMap());

  static List<CategoryIngredient> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((item) => CategoryIngredient.fromMap(item as Map<String, dynamic>))
        .toList();
  }
}
