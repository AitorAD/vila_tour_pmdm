import 'dart:convert';

import 'package:vila_tour_pmdm/src/models/models.dart';

class Festival extends Article {
  DateTime startDate;
  DateTime endDate;
  User creator;
  Coordinate coordinate;

  Festival({
    required String type,
    required int id,
    required String name,
    required String description,
    required double averageScore,
    required DateTime creationDate,
    required DateTime lastModificationDate,
    required List<Review> reviews,
    required List<Image> images,
    required this.startDate,
    required this.endDate,
    required this.creator,
    required this.coordinate,
  }) : super(
            id: id,
            name: name,
            description: description,
            averageScore: averageScore,
            creationDate: creationDate,
            lastModificationDate: lastModificationDate,
            reviews: reviews,
            images: images,
            type: 'festival');

  factory Festival.fromJson(String str) => Festival.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Festival.fromMap(Map<String, dynamic> json) => Festival(
        type: json["type"],
        id: json["id"],
        name: json["name"],
        description: json["description"],
        averageScore: json["averageScore"],
        creationDate: DateTime.parse(json["creationDate"]),
        lastModificationDate: DateTime.parse(json["lastModificationDate"]),
        reviews: json["reviews"] is List
            ? (json["reviews"] as List)
                .map((x) => Review.fromMap(x as Map<String, dynamic>))
                .toList()
            : [],
        images: json["images"] is List
            ? (json["images"] as List)
                .map((x) => Image.fromMap(x as Map<String, dynamic>))
                .toList()
            : [],
        startDate: DateTime.parse(json["startDate"]),
        endDate: DateTime.parse(json["endDate"]),
        creator: User.fromMap(json["creator"]),
        coordinate: Coordinate.fromMap(json["coordinate"]),
      );

  Map<String, dynamic> toMap() => {
        "type": type,
        "id": id,
        "name": name,
        "description": description,
        "averageScore": averageScore,
        "creationDate": creationDate.toIso8601String(),
        "lastModificationDate": lastModificationDate.toIso8601String(),
        "reviews": reviews.map((x) => x.toMap()).toList(),
        "images": reviews.map((x) => x.toMap()).toList(),
        "startDate":
            "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
        "endDate":
            "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
        "creator": creator.toMap(),
        "coordinate": coordinate.toMap(),
      };

  static List<Festival> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((item) => Festival.fromMap(item)).toList();
  }

  @override
  String toString() {
    return 'Festival(id: $id, name: $name, description: $description, averageScore: $averageScore, startDate: $startDate, endDate: $endDate)';
  }
}
