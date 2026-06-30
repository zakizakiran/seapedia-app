import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../data/providers/delivery_provider.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../data/services/auth_service.dart';

class DriverDashboardController extends GetxController {
  final DeliveryProvider _deliveryProvider = DeliveryProvider();
  final AuthProvider _authProvider = AuthProvider();
  final AuthService _authService = Get.find<AuthService>();

  final activeJob = Rxn<Map<String, dynamic>>();
  final jobHistory = <dynamic>[].obs;
  final totalEarnings = 0.0.obs;
  final isLoading = true.obs;
  final selectedIndex = 0.obs;

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

  @override
  void onInit() {
    super.onInit();
    fetchDashboard();
  }

  Future<void> fetchDashboard() async {
    try {
      isLoading.value = true;
      final data = await _deliveryProvider.getDashboard();
      activeJob.value = data['activeJob'];
      jobHistory.assignAll(data['jobHistory'] ?? []);
      totalEarnings.value = double.tryParse(data['totalEarnings']?.toString() ?? '0') ?? 0.0;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load dashboard: ${e.toString().replaceAll('Exception: ', '')}',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> completeActiveJob() async {
    if (activeJob.value == null) return;
    
    try {
      isLoading.value = true;
      await _deliveryProvider.completeJob(activeJob.value!['id']);
      Get.snackbar('Success', 'Job completed successfully!',
          backgroundColor: Colors.green, colorText: Colors.white);
      await fetchDashboard();
    } catch (e) {
      Get.snackbar('Error', 'Failed to complete job: ${e.toString().replaceAll('Exception: ', '')}',
          backgroundColor: Colors.red, colorText: Colors.white);
      isLoading.value = false;
    }
  }
}
