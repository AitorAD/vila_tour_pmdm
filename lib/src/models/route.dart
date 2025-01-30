import 'dart:convert';

import 'package:vila_tour_pmdm/src/models/models.dart';

class Route {
  int id;
  String name;
  List<Place> places;

  Route({
    required this.id,
    required this.name,
    required this.places,
  });

  factory Route.fromJson(String str) => Route.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Route.fromMap(Map<String, dynamic> json) => Route(
        id: json["id"],
        name: json["name"],
        places: List<Place>.from(json["places"].map((x) => Place.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "places": List<dynamic>.from(places.map((x) => x.toMap())),
      };

  static List<Route> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((item) => Route.fromMap(item)).toList();
  }
}
