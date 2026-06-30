import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../data/providers/admin_provider.dart';
import '../../../data/services/auth_service.dart';

class AdminDashboardController extends GetxController {
  final AdminProvider _adminProvider = AdminProvider();
  final AuthService _authService = Get.find<AuthService>();

  final selectedIndex = 0.obs;
  final isLoading = true.obs;

  // Dashboard Stats
  final usersCount = 0.obs;
  final storesCount = 0.obs;
  final productsCount = 0.obs;
  final ordersCount = 0.obs;
  final vouchersCount = 0.obs;
  final promosCount = 0.obs;
  final jobsCount = 0.obs;
  final overdueOrdersCount = 0.obs;

  // Discounts
  final vouchers = <dynamic>[].obs;
  final promos = <dynamic>[].obs;

  // Simulator/Overdue
  final timeInfo = Rxn<Map<String, dynamic>>();
  final overdueOrders = <dynamic>[].obs;

  // Forms
  final voucherCodeController = TextEditingController();
  final voucherAmountController = TextEditingController();
  final voucherPercentController = TextEditingController();
  final voucherUsageController = TextEditingController();
  final voucherExpiryDateController = TextEditingController();

  final promoCodeController = TextEditingController();
  final promoAmountController = TextEditingController();
  final promoPercentController = TextEditingController();
  final promoExpiryDateController = TextEditingController();

  String get userName => _authService.currentUser?.name ?? 'Admin User';
  String get userEmail => _authService.currentUser?.email ?? 'admin@seapedia.com';
  bool get hasMultipleRoles => (_authService.currentUser?.roles.length ?? 0) > 1;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardStats();
    fetchTimeInfo();
  }

  @override
  void onClose() {
    voucherCodeController.dispose();
    voucherAmountController.dispose();
    voucherPercentController.dispose();
    voucherUsageController.dispose();
    voucherExpiryDateController.dispose();
    promoCodeController.dispose();
    promoAmountController.dispose();
    promoPercentController.dispose();
    promoExpiryDateController.dispose();
    super.onClose();
  }

  void changeTab(int index) {
    selectedIndex.value = index;
    if (index == 0) fetchDashboardStats();
    if (index == 1) fetchDiscounts();
    if (index == 2) {
      fetchTimeInfo();
      fetchOverdueOrders();
    }
  }

  void logout() {
    _authService.logout();
  }

  Future<void> fetchDashboardStats({bool showLoading = true}) async {
    try {
      if (showLoading) isLoading.value = true;
      final data = await _adminProvider.getDashboardStats();
      final stats = data['stats'] ?? {};
      usersCount.value = stats['totalUsers'] ?? 0;
      storesCount.value = stats['totalStores'] ?? 0;
      productsCount.value = stats['totalProducts'] ?? 0;
      ordersCount.value = stats['totalOrders'] ?? 0;
      vouchersCount.value = stats['totalVouchers'] ?? 0;
      promosCount.value = stats['totalPromos'] ?? 0;
      jobsCount.value = stats['totalDeliveryJobs'] ?? 0;
      overdueOrdersCount.value = stats['overdueCount'] ?? 0;
    } catch (e) {
      _showError('Failed to load dashboard', e);
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  Future<void> fetchDiscounts() async {
    try {
      isLoading.value = true;
      final vouchersData = await _adminProvider.getVouchers();
      final promosData = await _adminProvider.getPromos();
      vouchers.assignAll(vouchersData['vouchers'] ?? []);
      promos.assignAll(promosData['promos'] ?? []);
    } catch (e) {
      _showError('Failed to load discounts', e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createVoucher() async {
    try {
      isLoading.value = true;
      final data = {
        'code': voucherCodeController.text.trim().toUpperCase(),
        'remainingUsage': int.tryParse(voucherUsageController.text) ?? 10,
        'expiryDate': voucherExpiryDateController.text.isNotEmpty 
            ? DateTime.parse(voucherExpiryDateController.text).toIso8601String()
            : DateTime.now().add(const Duration(days: 7)).toIso8601String(),
      };

      if (voucherAmountController.text.isNotEmpty) {
        data['discountAmount'] = double.parse(voucherAmountController.text);
      } else if (voucherPercentController.text.isNotEmpty) {
        data['discountPercent'] = double.parse(voucherPercentController.text);
      }

      await _adminProvider.createVoucher(data);
      Get.back(); // close dialog
      _showSuccess('Voucher created successfully');
      
      voucherCodeController.clear();
      voucherAmountController.clear();
      voucherPercentController.clear();
      voucherUsageController.clear();
      voucherExpiryDateController.clear();
      
      await fetchDiscounts();
    } catch (e) {
      _showError('Failed to create voucher', e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createPromo() async {
    try {
      isLoading.value = true;
      final Map<String, dynamic> data = {
        'code': promoCodeController.text.trim().toUpperCase(),
        'expiryDate': promoExpiryDateController.text.isNotEmpty 
            ? DateTime.parse(promoExpiryDateController.text).toIso8601String()
            : DateTime.now().add(const Duration(days: 7)).toIso8601String(),
      };

      if (promoAmountController.text.isNotEmpty) {
        data['discountAmount'] = double.parse(promoAmountController.text);
      } else if (promoPercentController.text.isNotEmpty) {
        data['discountPercent'] = double.parse(promoPercentController.text);
      }

      await _adminProvider.createPromo(data);
      Get.back(); // close dialog
      _showSuccess('Promo created successfully');
      
      promoCodeController.clear();
      promoAmountController.clear();
      promoPercentController.clear();
      promoExpiryDateController.clear();
      
      await fetchDiscounts();
    } catch (e) {
      _showError('Failed to create promo', e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> selectExpiryDate(bool isVoucher) async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) {
      final formattedDate = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      if (isVoucher) {
        voucherExpiryDateController.text = formattedDate;
      } else {
        promoExpiryDateController.text = formattedDate;
      }
    }
  }

  Future<void> fetchTimeInfo() async {
    try {
      final data = await _adminProvider.getTimeInfo();
      timeInfo.value = data;
    } catch (e) {
      _showError('Failed to get time info', e);
    }
  }

  Future<void> fetchOverdueOrders({bool showLoading = true}) async {
    try {
      if (showLoading) isLoading.value = true;
      final data = await _adminProvider.getOverdueOrders();
      overdueOrders.assignAll(data['orders'] ?? data['overdueOrders'] ?? []);
    } catch (e) {
      _showError('Failed to load overdue orders', e);
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  Future<void> simulateNextDay() async {
    try {
      await _adminProvider.simulateDay();
      await fetchTimeInfo();
      await fetchOverdueOrders(showLoading: false);
      await fetchDashboardStats(showLoading: false);
    } catch (e) {
      _showError('Failed to simulate day', e);
    }
  }

  Future<void> resetSimulatedTime() async {
    try {
      isLoading.value = true;
      await _adminProvider.resetSimulatedTime();
      _showSuccess('Time reset successfully');
      await fetchTimeInfo();
      await fetchOverdueOrders();
      await fetchDashboardStats();
    } catch (e) {
      _showError('Failed to reset time', e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> processOverdue() async {
    try {
      isLoading.value = true;
      final data = await _adminProvider.processOverdue();
      final processedCount = data['processedCount'] ?? 0;
      _showSuccess('Processed $processedCount overdue orders');
      await fetchOverdueOrders();
      await fetchDashboardStats();
    } catch (e) {
      _showError('Failed to process overdue orders', e);
    } finally {
      isLoading.value = false;
    }
  }

  void _showError(String title, Object e) {
    Get.snackbar(
      title,
      e.toString().replaceAll('Exception: ', ''),
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  void _showSuccess(String message) {
    Get.snackbar(
      'Success',
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}
