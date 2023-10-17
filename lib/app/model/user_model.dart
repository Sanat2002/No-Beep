// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(dynamic json) => UserModel.fromJson(json);

// String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
    String firstName;
    String lastName;
    String userName;
    String token;

    UserModel({
        required this.firstName,
        required this.lastName,
        required this.userName,
        required this.token,
    });

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        firstName: json["firstName"],
        lastName: json["lastName"],
        userName: json["userName"],
        token: json["token"],
    );

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "userName": userName,
        "token": token,
      };
}
