import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/auth_response_model.dart';

class AuthService extends GetxService {
  final _isLoggedIn = false.obs;
  final _currentUser = Rxn<UserModel>();
  
  bool get isLoggedIn => _isLoggedIn.value;
  UserModel? get currentUser => _currentUser.value;

  Future<AuthService> init() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    
    if (token != null) {
      final userStr = prefs.getString('user_data');
      if (userStr != null) {
        try {
          final userJson = jsonDecode(userStr);
          final user = UserModel.fromJson(userJson);
          _currentUser.value = user;
          
          final requiresRoleSelection = user.roles.length > 1 && user.activeRole == null;
          if (!requiresRoleSelection) {
            _isLoggedIn.value = true;
          }
        } catch (e) {
          debugPrint('Error parsing user data: $e');
          _isLoggedIn.value = true;
        }
      } else {
        _isLoggedIn.value = true;
      }
    }
    
    return this;
  }

  Future<void> saveAuthData(AuthResponseModel data) async {
    final prefs = await SharedPreferences.getInstance();
    
    if (data.accessToken != null) {
      await prefs.setString('access_token', data.accessToken!);
    }
    
    if (data.refreshToken != null) {
      await prefs.setString('refresh_token', data.refreshToken!);
    }
    
    if (data.user != null) {
      _currentUser.value = data.user;
      await prefs.setString('user_data', jsonEncode(data.user!.toJson()));
      
      if (data.requiresRoleSelection != true || data.activeRole != null) {
        _isLoggedIn.value = true;
      }
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    await prefs.remove('user_data');
    
    _isLoggedIn.value = false;
    _currentUser.value = null;
    
    Get.offAllNamed('/login');
  }
}
