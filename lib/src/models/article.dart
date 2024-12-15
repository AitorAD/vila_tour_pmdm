import 'models.dart';

abstract class Article {
  int id;
  String name;
  String description;
  double averageScore;
  DateTime creationDate;
  DateTime lastModificationDate;
  String type;
  List<Review> reviews;

  Article({
    required this.id,
    required this.name,
    required this.description,
    required this.averageScore,
    required this.creationDate,
    required this.lastModificationDate,
    required this.reviews,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "averageScore": averageScore,
      "creationDate": creationDate.toIso8601String(),
      "lastModificationDate": lastModificationDate.toIso8601String(),
      "type": type,
      "reviews": reviews.map((r) => r.toMap()).toList(),
    };
  }

  static Article fromMap(Map<String, dynamic> map) {
    switch (map['type']) {
      case 'Recipe':
        return Recipe.fromMap(map);
      case 'Place':
        return Place.fromMap(map);
      case 'Festival':
        return Festival.fromMap(map);
      default:
        throw Exception('Unknown article type: ${map['type']}');
    }
  }
}
