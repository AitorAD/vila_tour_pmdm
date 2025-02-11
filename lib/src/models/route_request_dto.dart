import 'dart:convert';

class RouteRequestDTO {
  List<List<double>> coordinates;
  String profile;

  RouteRequestDTO({
    required this.coordinates,
    required this.profile,
  });

  factory RouteRequestDTO.fromJson(String str) =>
      RouteRequestDTO.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RouteRequestDTO.fromMap(Map<String, dynamic> json) => RouteRequestDTO(
        coordinates: List<List<double>>.from(json["coordinates"]
            .map((x) => List<double>.from(x.map((x) => x?.toDouble())))),
        profile: json["profile"],
      );

  Map<String, dynamic> toMap() => {
        "coordinates": List<dynamic>.from(
            coordinates.map((x) => List<dynamic>.from(x.map((x) => x)))),
        "profile": profile,
      };
}


/*
class RouteRequestDTO {
  final List<List<double>> coordinates;
  final String profile;

  RouteRequestDTO({
    required this.coordinates,
    required this.profile,
  });

  // Convierte el objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      'coordinates': coordinates,
      'profile': profile,
    };
  }
}

class RouteResponse {
  final List<LatLng> coordinates;

  RouteResponse({required this.coordinates});

  // Convierte JSON a un objeto RouteResponse
  factory RouteResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> coords = json['geometry']['coordinates'];
    final List<LatLng> points = coords
        .map((coord) => LatLng(coord[1], coord[0])) // LatLng espera (lat, lng)
        .toList();
    return RouteResponse(coordinates: points);
  }
}
*/