import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../data/services/auth_service.dart';

class RoleSelectionController extends GetxController {
  final AuthProvider _authProvider = AuthProvider();
  final AuthService _authService = Get.find<AuthService>();

  final isLoading = false.obs;
  final availableRoles = <String>[].obs;
  final selectedRole = RxnString();

  @override
  void onInit() {
    super.onInit();
    final user = _authService.currentUser;
    if (user != null) {
      availableRoles.assignAll(user.roles);
    }
  }

  void selectRole(String role) {
    selectedRole.value = role;
  }

  Future<void> confirmRole() async {
    if (selectedRole.value == null) {
      Get.snackbar(
        'Warning',
        'Please select a role first',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    if (isLoading.value) return;

    try {
      isLoading.value = true;
      
      final response = await _authProvider.selectRole(selectedRole.value!);
      
      await _authService.saveAuthData(response);

      if (selectedRole.value == 'SELLER') {
        Get.offAllNamed('/seller-dashboard');
      } else if (selectedRole.value == 'DRIVER') {
        Get.offAllNamed('/driver-dashboard');
      } else {
        Get.offAllNamed('/home');
      }
      
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
