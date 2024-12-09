import 'dart:convert';

class User {
  int id;
  String username;
  String email;
  String password;
  String role;
  String? name;
  String? surname;
  String? profilePicture;
  List<dynamic> createdRecipes;
  List<dynamic> createdFestivals;
  List<dynamic> createdPlaces;
  List<dynamic> reviews;

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

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        password: json["password"],
        role: json["role"],
        name: json["name"],
        surname: json["surname"],
        profilePicture: json["profilePicture"],
        createdRecipes:
            List<dynamic>.from(json["createdRecipes"].map((x) => x)),
        createdFestivals:
            List<dynamic>.from(json["createdFestivals"].map((x) => x)),
        createdPlaces: List<dynamic>.from(json["createdPlaces"].map((x) => x)),
        reviews: List<dynamic>.from(json["reviews"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "username": username,
        "email": email,
        "password": password,
        "role": role,
        "name": name,
        "surname": surname,
        "profilePicture": profilePicture,
        "createdRecipes": List<dynamic>.from(createdRecipes.map((x) => x)),
        "createdFestivals": List<dynamic>.from(createdFestivals.map((x) => x)),
        "createdPlaces": List<dynamic>.from(createdPlaces.map((x) => x)),
        "reviews": List<dynamic>.from(reviews.map((x) => x)),
      };

  @override
  String toString() {
    return 'User{id: $id, username: $username, email: $email, role: $role, name: $name, surname: $surname, profilePicture: $profilePicture, createdRecipes: $createdRecipes, createdFestivals: $createdFestivals, createdPlaces: $createdPlaces, reviews: $reviews}';
  }
}
