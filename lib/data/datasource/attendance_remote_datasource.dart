import 'package:dartz/dartz.dart';
import 'package:flutter_attendance_app/data/datasource/auth_local_datasource.dart';
import 'package:flutter_attendance_app/data/model/request/update_request_model.dart';
import 'package:flutter_attendance_app/data/model/response/user_response_model.dart';
import 'package:http/http.dart' as http;

import '../../core/constants/variables.dart';

class AttendanceRemoteDatasource {
  Future<Either<String, UserResponseModel>> updateProfileRegisterFace(
      UpdateRequestModel requestModel) async {
    final authData = await AuthLocalDataSource().getAuthData();
    final Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${authData!.token}'
    };
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${Variables.baseUrl}/api/update-profile'),
    );

    request.fields.addAll(requestModel.toMap());
    request.files.add(
        await http.MultipartFile.fromPath('image', requestModel.image!.path));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    final String body = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return right(UserResponseModel.fromJson(body));
    } else {
      return left(body);
    }
  }
}
