class Ingredient {
  final int id;
  final String name;
  final String category;

  Ingredient({
    required this.id,
    required this.name,
    required this.category,
  });

  factory Ingredient.fromMap(Map<String, dynamic> map) {
    return Ingredient(
      id: map['idIngredient'] ?? 0,
      name: map['name'] ?? 'Unknown',
      category: map['category'] ?? 'Unknown',
    );
  }

   @override
  String toString() {
    return name;  // Devuelve el nombre del ingrediente
  }
}
