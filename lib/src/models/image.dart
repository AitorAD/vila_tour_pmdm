import 'dart:convert';

class Image {
  int? id;
  String path;

  Image({
    this.id,
    required this.path,
  });

  factory Image.fromJson(String str) => Image.fromMap(json.decode(str));

  Map<String, dynamic> toJson() => toMap();

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
    return 'Image(id: $id, path: $path)';
  }
}