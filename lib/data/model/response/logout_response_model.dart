import 'dart:convert';

class LogoutResponseModel {
  final String? message;

  LogoutResponseModel({
    this.message,
  });

  factory LogoutResponseModel.fromJson(String str) =>
      LogoutResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LogoutResponseModel.fromMap(Map<String, dynamic> json) =>
      LogoutResponseModel(
        message: json["message"],
      );

  Map<String, dynamic> toMap() => {
        "message": message,
      };
}
