class CategoryIngredient {
  final int id;
  final String name;

  CategoryIngredient({
    required this.id,
    required this.name,
  });

  factory CategoryIngredient.fromMap(Map<String, dynamic> map) {
    return CategoryIngredient(
      id: map['idCategory'] ?? 0,
      name: map['name'] ?? 'Unknown',
    );
  }
}