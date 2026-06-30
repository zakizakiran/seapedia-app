import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../data/providers/delivery_provider.dart';

class DriverJobsController extends GetxController {
  final DeliveryProvider _deliveryProvider = DeliveryProvider();

  final availableJobs = <dynamic>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchJobs();
  }

  Future<void> fetchJobs() async {
    try {
      isLoading.value = true;
      final jobs = await _deliveryProvider.getAvailableJobs();
      availableJobs.assignAll(jobs);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load jobs: ${e.toString().replaceAll('Exception: ', '')}',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}
