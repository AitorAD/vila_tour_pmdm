import 'dart:convert';
import 'package:vila_tour_pmdm/src/models/article.dart';

class Image {
  int? id;
  String path;
  Article? article;

  Image({
    this.id,
    required this.path,
    this.article
  });

  factory Image.fromJson(String str) => Image.fromMap(json.decode(str));

  Map<String, dynamic> toJson() => toMap();

  factory Image.fromMap(Map<String, dynamic> json) => Image(
        id: json["id"],
        path: json["path"],
        article: json["article"]
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "path": path,
        "article": article
      };

  static List<Image> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((item) => Image.fromMap(item)).toList();
  }

  @override
  String toString() {
    return 'Image(id: $id, path: $path, article $article)';
  }
}