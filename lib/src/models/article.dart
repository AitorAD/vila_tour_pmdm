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
  List<Image> images;

  Article({
    required this.id,
    required this.name,
    required this.description,
    required this.averageScore,
    required this.creationDate,
    required this.lastModificationDate,
    required this.reviews,
    required this.images,
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
      "images": images.map((i) => i.toMap()).toList(),
    };
  }

  static Article fromMap(Map<String, dynamic> map) {
    switch (map['type']) {
      case 'recipe':
        return Recipe.fromMap(map);
      case 'place':
        return Place.fromMap(map);
      case 'festival':
        return Festival.fromMap(map);
      default:
        throw Exception('Unknown article type: ${map['type']}');
    }
  }

  static List<Article> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((item) => Article.fromMap(item)).toList();
  }
}
