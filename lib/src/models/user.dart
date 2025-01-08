import 'dart:convert';

import 'package:vila_tour_pmdm/src/models/models.dart';

class User {
  int id;
  String username;
  String email;
  String password;
  String role;
  String? name;
  String? surname;
  String? profilePicture;
  List<Recipe> createdRecipes;
  List<Festival> createdFestivals;
  List<Place> createdPlaces;
  List<Review> reviews;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.role,
    required this.name,
    required this.surname,
    required this.profilePicture,
    required this.createdRecipes,
    required this.createdFestivals,
    required this.createdPlaces,
    required this.reviews,
  });

  User copyWith({
    int? id,
    String? username,
    String? email,
    String? password,
    String? role,
    String? name,
    String? surname,
    String? profilePicture,
    List<Recipe>? createdRecipes,
    List<Festival>? createdFestivals,
    List<Place>? createdPlaces,
    List<Review>? reviews,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      profilePicture: profilePicture ?? this.profilePicture,
      createdRecipes: createdRecipes ?? List.from(this.createdRecipes),
      createdFestivals: createdFestivals ?? List.from(this.createdFestivals),
      createdPlaces: createdPlaces ?? List.from(this.createdPlaces),
      reviews: reviews ?? List.from(this.reviews),
    );
  }

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"] ?? 0,
        username: json["username"],
        email: json["email"] ?? "null",
        password: json["password"] ?? "null",
        role: json["role"] ?? "null",
        name: json["name"] ?? "null",
        surname: json["surname"] ?? "null",
        profilePicture: json["profilePicture"],
        createdRecipes: List<Recipe>.from(
            json["createdRecipes"]?.map((x) => Recipe.fromMap(x)) ?? []),
        createdFestivals: List<Festival>.from(
            json["createdFestivals"]?.map((x) => Festival.fromMap(x)) ?? []),
        createdPlaces: List<Place>.from(
            json["createdPlaces"]?.map((x) => Place.fromMap(x)) ?? []),
        reviews: List<Review>.from(
            json["reviews"]?.map((x) => Review.fromMap(x)) ?? []),
      );

  // Método existente para mapear todos los campos
  Map<String, dynamic> toMap() => {
        "id": id,
        "username": username,
        "email": email,
        "password": password,
        "role": role,
        "name": name,
        "surname": surname,
        "profilePicture": profilePicture,
        "createdRecipes": List<Recipe>.from(createdRecipes.map((x) => x)),
        "createdFestivals": List<Festival>.from(createdFestivals.map((x) => x)),
        "createdPlaces": List<Place>.from(createdPlaces.map((x) => x)),
        "reviews": List<Review>.from(reviews.map((x) => x)),
      };

  // Nuevo método para mapear solo el ID
  Map<String, dynamic> toMapMinimal() => {
        "id": id,
      };

  @override
  String toString() {
    return 'User{id: $id, username: $username, email: $email, role: $role, name: $name, surname: $surname, profilePicture: $profilePicture, createdRecipes: $createdRecipes, createdFestivals: $createdFestivals, createdPlaces: $createdPlaces, reviews: $reviews}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.id == id &&
        other.username == username &&
        other.email == email &&
        other.name == name &&
        other.surname == surname &&
        other.profilePicture == profilePicture;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        username.hashCode ^
        email.hashCode ^
        name.hashCode ^
        surname.hashCode ^
        profilePicture.hashCode;
  }
}
