import 'dart:convert';

class UserLogData {
    String token;
    String type;
    String refreshToken;
    int id;
    String username;
    String email;
    String role;

    UserLogData({
        required this.token,
        required this.type,
        required this.refreshToken,
        required this.id,
        required this.username,
        required this.email,
        required this.role,
    });

    factory UserLogData.fromJson(String str) => UserLogData.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory UserLogData.fromMap(Map<String, dynamic> json) => UserLogData(
        token: json["token"],
        type: json["type"],
        refreshToken: json["refreshToken"],
        id: json["id"],
        username: json["username"],
        email: json["email"],
        role: json["role"],
    );

    Map<String, dynamic> toMap() => {
        "token": token,
        "type": type,
        "refreshToken": refreshToken,
        "id": id,
        "username": username,
        "email": email,
        "role": role,
    };
}
