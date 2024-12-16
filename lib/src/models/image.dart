import 'dart:convert';
import 'package:vila_tour_pmdm/src/models/models.dart';

class Image {
  int? id;
  String path;

  Image({
    this.id,
    required this.path,
  });

  factory Image.fromJson(String str) => Image.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Image.fromMap(Map<String, dynamic> json) => Image(
        id: json["id"],
        path: json["path"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "path": path,
      };

  static List<Image> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((item) => Image.fromMap(item)).toList();
  }

  @override
  String toString() {
    return 'Festival(id: $id, path: $path)';
  }
}
