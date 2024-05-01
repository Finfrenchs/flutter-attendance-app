import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_attendance_app/data/datasource/auth_local_datasource.dart';
import 'package:flutter_attendance_app/data/model/request/update_request_model.dart';
import 'package:flutter_attendance_app/data/model/response/checkin_response_model.dart';
import 'package:flutter_attendance_app/data/model/response/checkout_response_model.dart';
import 'package:flutter_attendance_app/data/model/response/user_response_model.dart';
import 'package:http/http.dart' as http;

import '../../core/constants/variables.dart';

class AttendanceRemoteDatasource {
  Future<Either<String, UserResponseModel>> updateProfileRegisterFace(
    String embedding,
  ) async {
    final authData = await AuthLocalDataSource().getAuthData();
    final url = Uri.parse('${Variables.baseUrl}/api/update-profile');
    final request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = 'Bearer ${authData?.token}'
      ..fields['face_embedding'] = embedding;

    final response = await request.send();
    final responseString = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return Right(UserResponseModel.fromJson(responseString));
    } else {
      return const Left('Failed to update profile');
    }
  }

  Future<Either<String, CheckinResponseModel>> checkin(
      String latitude, String longitude) async {
    final authData = await AuthLocalDataSource().getAuthData();
    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${authData!.token}',
      'Content-Type': 'application/json'
    };
    final url = Uri.parse('${Variables.baseUrl}/api/checkin');
    final response = await http.post(
      url,
      body: json.encode({"latitude": latitude, "longitude": longitude}),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return Right(CheckinResponseModel.fromJson(response.body));
    } else {
      return const Left('Gagal absen');
    }
  }

  Future<Either<String, CheckOutResponseModel>> checkout(
      String latitude, String longitude) async {
    final authData = await AuthLocalDataSource().getAuthData();
    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${authData!.token}',
      'Content-Type': 'application/json'
    };
    final url = Uri.parse('${Variables.baseUrl}/api/checkout');
    final response = await http.post(
      url,
      body: json.encode({"latitude": latitude, "longitude": longitude}),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return Right(CheckOutResponseModel.fromJson(response.body));
    } else {
      return const Left('Gagal absen');
    }
  }
}
