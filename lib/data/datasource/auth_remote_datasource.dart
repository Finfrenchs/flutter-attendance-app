import 'package:dartz/dartz.dart';
import 'package:flutter_attendance_app/data/datasource/auth_local_datasource.dart';
import 'package:flutter_attendance_app/data/model/request/login_request_model.dart';
import 'package:flutter_attendance_app/data/model/response/login_response_model.dart';
import 'package:flutter_attendance_app/data/model/response/logout_response_model.dart';
import 'package:http/http.dart' as http;

import '../../core/constants/variables.dart';

class AuthRemoteDatasource {
  Future<Either<String, LoginResponseModel>> login(
      LoginRequestModel requestModel) async {
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };
    final url = Uri.parse('${Variables.baseUrl}/api/login');
    final response = await http.post(
      url,
      body: requestModel.toJson(),
      headers: headers,
    );

    if (response.statusCode == 200) {
      await AuthLocalDataSource()
          .saveAuthData(LoginResponseModel.fromJson(response.body));
      return Right(LoginResponseModel.fromJson(response.body));
    } else {
      return const Left('Gagal login');
    }
  }

  Future<Either<String, LogoutResponseModel>> logout() async {
    final authDataModel = await AuthLocalDataSource().getAuthData();
    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${authDataModel?.token}',
    };
    final url = Uri.parse('${Variables.baseUrl}/api/logout');
    final response = await http.post(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      await AuthLocalDataSource().removeAuthData();
      return Right(LogoutResponseModel.fromJson(response.body));
    } else {
      return const Left('Logout gagal');
    }
  }
}
