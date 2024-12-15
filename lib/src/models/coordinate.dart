import 'dart:convert';

class Coordinate {
  int id;
  String name;
  double latitude;
  double longitude;

  Coordinate({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory Coordinate.fromJson(String str) =>
      Coordinate.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Coordinate.fromMap(Map<String, dynamic> json) => Coordinate(
        id: json["id"],
        name: json["name"],
        latitude: json["latitude"] != null ? json["latitude"].toDouble() : 0.0,
        longitude:
            json["longitude"] != null ? json["longitude"].toDouble() : 0.0,
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "latitude": latitude,
        "longitude": longitude,
      };
}
