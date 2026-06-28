import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/services/auth_service.dart';
import 'app_pages.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authService = Get.find<AuthService>();
    if (!authService.isLoggedIn) {
      if (authService.currentUser != null) {
        return const RouteSettings(name: Routes.ROLE_SELECTION);
      }
      return const RouteSettings(name: Routes.LOGIN);
    }
    return null;
  }
}
