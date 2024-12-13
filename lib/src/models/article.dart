abstract class Article {
  int id;
  String name;
  String description;
  double averageScore;
  DateTime creationDate;
  DateTime lastModificationDate;
  String type;
  List<dynamic> reviews;

  Article({
    required this.id,
    required this.name,
    required this.description,
    required this.averageScore,
    required this.creationDate,
    required this.lastModificationDate,
    required this.reviews,
    required this.type
  });
}
