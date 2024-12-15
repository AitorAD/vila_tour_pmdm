import 'dart:convert';

class CategoryPlace {
    int id;
    String name;

    CategoryPlace({
        required this.id,
        required this.name,
    });

    factory CategoryPlace.fromJson(String str) => CategoryPlace.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory CategoryPlace.fromMap(Map<String, dynamic> json) => CategoryPlace(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
    };
}