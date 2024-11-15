class Article {
  int id;
  String name;
  String description;
  dynamic imagensPaths;
  double averageScore;
  DateTime creationDate;
  DateTime lastModificationDate;
  List<dynamic> reviews;

  Article({
    required this.id,
    required this.name,
    required this.description,
    required this.imagensPaths,
    required this.averageScore,
    required this.creationDate,
    required this.lastModificationDate,
    required this.reviews,
  });

  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      id: map['id'] ?? 0,
      name: map['name'] ?? 'No name',
      description: map['description'] ?? 'No description available',
      imagensPaths: map['imagensPaths'] ??
          'https://www.cams-it.com/wp-content/uploads/2015/05/default-placeholder-300x200.png',
      averageScore: map['averageScore'] ?? 0.0,
      creationDate: DateTime.parse(map['creationDate']),
      lastModificationDate: DateTime.parse(map['lastModificationDate']),
      reviews: List<dynamic>.from(map["reviews"].map((x) => x)),
    );
  }
}
