import 'dart:convert';

class AddPermissionResponseModel {
  final bool? success;
  final String? message;
  final Data? data;

  AddPermissionResponseModel({
    this.success,
    this.message,
    this.data,
  });

  factory AddPermissionResponseModel.fromJson(String str) =>
      AddPermissionResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AddPermissionResponseModel.fromMap(Map<String, dynamic> json) =>
      AddPermissionResponseModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data": data?.toMap(),
      };
}

class Data {
  final int? userId;
  final DateTime? datePermission;
  final String? reason;
  final bool? isApproval;
  final String? image;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final int? id;

  Data({
    this.userId,
    this.datePermission,
    this.reason,
    this.isApproval,
    this.image,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Data.fromMap(Map<String, dynamic> json) => Data(
        userId: json["user_id"],
        datePermission: json["date_permission"] == null
            ? null
            : DateTime.parse(json["date_permission"]),
        reason: json["reason"],
        isApproval: json["is_approval"],
        image: json["image"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toMap() => {
        "user_id": userId,
        "date_permission": datePermission?.toIso8601String(),
        "reason": reason,
        "is_approval": isApproval,
        "image": image,
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "id": id,
      };
}
