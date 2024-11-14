import 'dart:convert';
import 'package:vila_tour_pmdm/src/models/article.dart';

class Festival extends Article {
  DateTime startDate;
  DateTime endDate;
  dynamic coordinade;

  Festival({
    required int id,
    required String name,
    required String description,
    required dynamic imagensPaths,
    required double averageScore,
    required DateTime creationDate,
    required DateTime lastModificationDate,
    required List<dynamic> reviews,
    required this.startDate,
    required this.endDate,
    required this.coordinade,
  }) : super(
          id: id,
          name: name,
          description: description,
          imagensPaths: imagensPaths,
          averageScore: averageScore,
          creationDate: creationDate,
          lastModificationDate: lastModificationDate,
          reviews: reviews,
        );

  factory Festival.fromJson(String str) => Festival.fromMap(json.decode(str));

  factory Festival.fromMap(Map<String, dynamic> json) => Festival(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        imagensPaths: json["imagensPaths"],
        averageScore: json["averageScore"]?.toDouble(),
        creationDate: DateTime.parse(json["creationDate"]),
        lastModificationDate: DateTime.parse(json["lastModificationDate"]),
        reviews: List<dynamic>.from(json["reviews"].map((x) => x)),
        startDate: DateTime.parse(json["startDate"]),
        endDate: DateTime.parse(json["endDate"]),
        coordinade: json["coordinade"],
      );

  // Método de fábrica para una lista de Festival
  static List<Festival> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((item) => Festival.fromMap(item)).toList();
  }

  @override
  String toString() {
    return 'Festival(id: $id, name: $name, description: $description, averageScore: $averageScore, startDate: $startDate, endDate: $endDate)';
  }
}
