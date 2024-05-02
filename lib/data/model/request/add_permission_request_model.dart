import 'dart:convert';

import 'package:image_picker/image_picker.dart';

class AddPermissionRequestModel {
  final String datePermission;
  final String reason;
  final XFile? image;
  AddPermissionRequestModel({
    required this.datePermission,
    required this.reason,
    this.image,
  });

  Map<String, String> toMap() {
    return <String, String>{
      'date_permission': datePermission,
      'reason': reason,
    };
  }

  factory AddPermissionRequestModel.fromMap(Map<String, dynamic> map) {
    return AddPermissionRequestModel(
      datePermission: map['date_permission'] as String,
      reason: map['reason'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AddPermissionRequestModel.fromJson(String source) =>
      AddPermissionRequestModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
