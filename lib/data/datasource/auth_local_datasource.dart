import 'package:flutter_attendance_app/data/model/response/login_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDataSource {
  Future<void> saveAuthData(LoginResponseModel authResponseModel) async {
    // Save auth data to local storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_data', authResponseModel.toJson());
  }

  Future<void> removeAuthData() async {
    // Remove auth data from local storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_data');
  }

  Future<LoginResponseModel?> getAuthData() async {
    // Get auth data from local storage
    final prefs = await SharedPreferences.getInstance();
    final authData = prefs.getString('auth_data');
    if (authData != null) {
      return LoginResponseModel.fromJson(authData);
    } else {
      return null;
    }
  }

  Future<bool> isUserLoggedIn() async {
    // Check if user is logged in
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('auth_data');
  }
}
