// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class User {
  User({
    required this.id,
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    required this.expiresAt,
    required this.updatedAt,
    required this.createdAt,
    required this.userUuid,
  });

  int id;
  String accessToken;
  String refreshToken;
  int userId;
  DateTime? expiresAt;
  DateTime? updatedAt;
  DateTime? createdAt;
  String userUuid;

  User copyWith({
    int? id,
    String? accessToken,
    String? refreshToken,
    int? userId,
    DateTime? expiresAt,
    DateTime? updatedAt,
    DateTime? createdAt,
    String? userUuid,
  }) =>
      User(
        id: id ?? this.id,
        accessToken: accessToken ?? this.accessToken,
        refreshToken: refreshToken ?? this.refreshToken,
        userId: userId ?? this.userId,
        expiresAt: expiresAt ?? this.expiresAt,
        updatedAt: updatedAt ?? this.updatedAt,
        createdAt: createdAt ?? this.createdAt,
        userUuid: userUuid ?? this.userUuid,
      );

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    accessToken: json["accessToken"],
    refreshToken: json["refreshToken"],
    userId: json["userId"],
    expiresAt: DateTime.tryParse(json["expiresAt"]),
    updatedAt: DateTime.tryParse(json["expiresAt"]),
    createdAt: DateTime.tryParse(json["expiresAt"]),
    userUuid: json["userUuid"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "accessToken": accessToken,
    "refreshToken": refreshToken,
    "userId": userId,
    "expiresAt": expiresAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "userUuid": userUuid,
  };
}
