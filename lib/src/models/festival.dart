import 'dart:convert';

import 'package:vila_tour_pmdm/src/models/models.dart';

class Festival extends Article {
  DateTime startDate;
  DateTime endDate;
  User creator;
  Coordinate coordinate;

  Festival({
    required type,
    required id,
    required name,
    required description,
    required averageScore,
    required creationDate,
    required lastModificationDate,
    required reviews,
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
        reviews: json["reviews"] != null
            ? List<Review>.from(json["reviews"].map((x) => x))
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
        "reviews": List<Review>.from(reviews.map((x) => x)),
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
