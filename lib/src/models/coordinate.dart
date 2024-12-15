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
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "latitude": latitude,
        "longitude": longitude,
      };
}
