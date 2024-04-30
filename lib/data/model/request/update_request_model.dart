// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:camera/camera.dart';

class UpdateRequestModel {
  final XFile? image;
  final String faceEmbedding;
  UpdateRequestModel({
    this.image,
    required this.faceEmbedding,
  });

  Map<String, String> toMap() {
    return <String, String>{
      //'image': image?.toMap(),
      'faceEmbedding': faceEmbedding,
    };
  }

  factory UpdateRequestModel.fromMap(Map<String, dynamic> map) {
    return UpdateRequestModel(
      //image: map['image'] != null ? XFile.fromMap(map['image'] as Map<String,dynamic>) : null,
      faceEmbedding: map['faceEmbedding'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateRequestModel.fromJson(String source) =>
      UpdateRequestModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
