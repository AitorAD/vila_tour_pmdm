import 'dart:convert';
import 'package:vila_tour_pmdm/src/models/models.dart';

class Image {
  int id;
  String path;
  Article article;

  Image({
    required this.id,
    required this.path,
    required this.article,
  });

  factory Image.fromJson(String str) => Image.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Image.fromMap(Map<String, dynamic> json) => Image(
        id: json["id"],
        path: json["path"],
        article: Article.fromMap(json["article"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "path": path,
        "article": article.toMap(),
      };

  
  static List<Image> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((item) => Image.fromMap(item)).toList();
  }
}
