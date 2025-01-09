import 'dart:convert';

import 'models.dart';

class Place extends Article {
  CategoryPlace categoryPlace;
  User creator;
  Coordinate coordinate;

  Place({
    required type,
    required id,
    required name,
    required description,
    required averageScore,
    required creationDate,
    required lastModificationDate,
    required reviews,
    required images,
    required this.categoryPlace,
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
            type: 'place');

  factory Place.fromJson(String str) => Place.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Place.fromMap(Map<String, dynamic> json) => Place(
        type: json["type"],
        id: json["id"],
        name: json["name"],
        description: json["description"],
        averageScore: json["averageScore"]?.toDouble(),
        creationDate: DateTime.parse(json["creationDate"]),
        lastModificationDate: DateTime.parse(json["lastModificationDate"]),
        reviews: json["reviews"] != null
            ? List<Review>.from(json["reviews"].map((x) => Review.fromMap(x)))
            : [],
        images: json["images"] is List
            ? (json["images"] as List)
                .map((x) => Image.fromMap(x as Map<String, dynamic>))
                .toList()
            : [],
        categoryPlace: CategoryPlace.fromMap(json["categoryPlace"]),
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
        "images": images.map((x) => x.toMap()).toList(),
        "categoryPlace": categoryPlace.toMap(),
        "creator": creator.toMap(),
        "coordinate": coordinate.toMap(),
      };

  static List<Place> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((item) => Place.fromMap(item)).toList();
  }
}
