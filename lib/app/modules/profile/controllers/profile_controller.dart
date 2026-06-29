import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/providers/report_provider.dart';

class ProfileController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final AuthProvider _authProvider = AuthProvider();

  final RxMap<String, dynamic> profileData = <String, dynamic>{}.obs;
  final RxBool isLoading = true.obs;
  final RxDouble totalSpending = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  final ReportProvider _reportProvider = ReportProvider();

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      final data = await _authProvider.getProfile();
      profileData.value = data;
      
      try {
        final spendingData = await _reportProvider.getBuyerSpending();
        totalSpending.value = double.parse(spendingData['totalSpending']?.toString() ?? '0');
      } catch (_) {}
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch profile: ${e.toString().replaceAll('Exception: ', '')}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addRole(String role) async {
    try {
      isLoading.value = true;
      final response = await _authProvider.addRole(role);
      await _authService.saveAuthData(response);
      await fetchProfile();
      Get.snackbar('Success', 'Successfully became a $role!',
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Failed to add role: ${e.toString().replaceAll('Exception: ', '')}',
          backgroundColor: Colors.red, colorText: Colors.white);
      isLoading.value = false;
    }
  }

  void logout() {
    _authService.logout();
  }
}
