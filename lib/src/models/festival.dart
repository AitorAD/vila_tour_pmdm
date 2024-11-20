import 'dart:convert';
import 'package:vila_tour_pmdm/src/models/article.dart';

class Festival extends Article {
  DateTime startDate;
  DateTime endDate;
  dynamic coordinade;

  Festival({
    required super.id,
    required super.name,
    required super.description,
    required super.imagensPaths,
    required super.averageScore,
    required super.creationDate,
    required super.lastModificationDate,
    required super.reviews,
    required this.startDate,
    required this.endDate,
    required this.coordinade,
  });

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
        // startDate: DateTime.parse(json["startDate"]),
        // endDate: DateTime.parse(json["endDate"]),
        startDate: json["startDate"] is String
            ? DateTime.tryParse(json["startDate"]) ?? DateTime.now()
            : DateTime.now(),
        endDate: json["endDate"] is String
            ? DateTime.tryParse(json["endDate"]) ?? DateTime.now()
            : DateTime.now(),
        coordinade: json["coordinade"],
      );

  // Método de fábrica para una lista de Festival
  static List<Festival> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((item) => Festival.fromMap(item)).toList();
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "description": description,
        "imagensPaths": imagensPaths,
        "averageScore": averageScore,
        "creationDate": creationDate.toIso8601String(),
        "lastModificationDate": lastModificationDate.toIso8601String(),
        "reviews": List<dynamic>.from(reviews.map((x) => x)),
        "startDate":
            "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
        "endDate":
            "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
        "coordinade": coordinade,
      };

  @override
  String toString() {
    return 'Festival(id: $id, name: $name, description: $description, averageScore: $averageScore, startDate: $startDate, endDate: $endDate)';
  }
}
