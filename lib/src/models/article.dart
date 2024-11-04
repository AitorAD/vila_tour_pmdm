class Article {
  int id;
  String name;
  String description;
  String imagePath;
  double averageScore;
  bool favourite;

  Article({
    required this.id,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.averageScore,
    required this.favourite,
  });

  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      id: map['id'] ?? 0,
      name: map['name'] ?? 'No name',
      description: map['description'] ?? 'No description available',
      imagePath: map['imagePath'] ?? 'https://www.cams-it.com/wp-content/uploads/2015/05/default-placeholder-300x200.png',
      averageScore: map['averageScore'] ?? 0.0,
      favourite: map['favourite'] ?? false,
    );
  }
}
