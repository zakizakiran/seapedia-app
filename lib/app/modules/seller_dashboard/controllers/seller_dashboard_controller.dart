import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/providers/auth_provider.dart';
import 'package:flutter/material.dart';

class SellerDashboardController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final AuthProvider _authProvider = AuthProvider();
  
  final RxInt selectedIndex = 0.obs;
  final isLoading = false.obs;

  bool get hasMultipleRoles {
    final user = _authService.currentUser;
    return user != null && user.roles.length > 1;
  }

  String get activeRole {
    return _authService.currentUser?.activeRole ?? '';
  }

  String get userName => _authService.currentUser?.name ?? 'Unknown User';
  String get userEmail => _authService.currentUser?.email ?? 'Unknown Email';

  List<String> get availableRoles {
    return _authService.currentUser?.roles ?? [];
  }

  void changeTab(int index) {
    selectedIndex.value = index;
  }

  Future<void> addRole(String role) async {
    try {
      isLoading.value = true;
      final response = await _authProvider.addRole(role);
      await _authService.saveAuthData(response);
      Get.snackbar('Success', 'Successfully became a $role!',
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Failed to add role: ${e.toString().replaceAll('Exception: ', '')}',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    _authService.logout();
  }
}
