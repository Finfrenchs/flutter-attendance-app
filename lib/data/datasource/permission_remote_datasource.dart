import 'package:dartz/dartz.dart';
import 'package:flutter_attendance_app/data/datasource/auth_local_datasource.dart';
import 'package:flutter_attendance_app/data/model/request/add_permission_request_model.dart';
import 'package:flutter_attendance_app/data/model/response/add_permission_response_model.dart';
import 'package:http/http.dart' as http;

import '../../core/constants/variables.dart';

class PermissionRemoteDatasource {
  Future<Either<String, AddPermissionResponseModel>> addPermission(
      AddPermissionRequestModel requestModel) async {
    final authData = await AuthLocalDataSource().getAuthData();
    final Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${authData!.token}'
    };
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${Variables.baseUrl}/api/api-permissions'),
    );

    request.fields.addAll(requestModel.toMap());
    request.files.add(
        await http.MultipartFile.fromPath('image', requestModel.image!.path));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    final String body = await response.stream.bytesToString();

    if (response.statusCode == 201) {
      return right(AddPermissionResponseModel.fromJson(body));
    } else {
      return left(body);
    }
  }
}
