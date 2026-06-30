import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../data/providers/delivery_provider.dart';

class DriverJobDetailController extends GetxController {
  final DeliveryProvider _deliveryProvider = DeliveryProvider();

  final jobId = ''.obs;
  final job = Rxn<Map<String, dynamic>>();
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    jobId.value = Get.arguments as String? ?? '';
    if (jobId.value.isNotEmpty) {
      fetchJobDetail();
    }
  }

  Future<void> fetchJobDetail() async {
    try {
      isLoading.value = true;
      final data = await _deliveryProvider.getJobDetail(jobId.value);
      job.value = data;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load job detail: ${e.toString().replaceAll('Exception: ', '')}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> takeJob() async {
    try {
      isLoading.value = true;
      await _deliveryProvider.takeJob(jobId.value);
      Get.snackbar(
        'Success',
        'Job taken successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.offAllNamed('/driver-dashboard');
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to take job: ${e.toString().replaceAll('Exception: ', '')}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      isLoading.value = false;
    }
  }
}
