import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/string_extensions.dart';
import '../../../data/models/store_model.dart';
import '../../../data/providers/store_provider.dart';
import '../../../data/providers/report_provider.dart';

class StoreProfileController extends GetxController {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final StoreProvider _storeProvider = StoreProvider();
  final ReportProvider _reportProvider = ReportProvider();
  
  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;
  final Rx<StoreModel?> currentStore = Rx<StoreModel?>(null);
  final RxDouble totalIncome = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadStoreProfile();
  }

  @override
  void onClose() {
    // Delay disposing controllers to prevent 'used after being disposed' 
    // exceptions when navigating away quickly (e.g., logout).
    final nController = nameController;
    final dController = descriptionController;
    Future.delayed(const Duration(milliseconds: 500), () {
      nController.dispose();
      dController.dispose();
    });
    super.onClose();
  }

  Future<void> _loadStoreProfile() async {
    try {
      isLoading.value = true;
      final store = await _storeProvider.getMyStore();
      currentStore.value = store;
      
      if (store != null) {
        nameController.text = store.name.unescapeHtml;
        descriptionController.text = store.description.unescapeHtml;
        
        try {
          final incomeData = await _reportProvider.getSellerIncome();
          totalIncome.value = double.parse(incomeData['totalIncome']?.toString() ?? '0');
        } catch (_) {}
      }
    } catch (e) {
      Get.snackbar('Error', e.toString().replaceAll('Exception: ', ''),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveStore() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isSaving.value = true;
      StoreModel savedStore;
      
      if (currentStore.value == null) {
        // Create
        savedStore = await _storeProvider.createStore(
          name: nameController.text.trim(),
          description: descriptionController.text.trim(),
        );
        Get.snackbar('Success', 'Store created successfully',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        // Update
        savedStore = await _storeProvider.updateStore(
          name: nameController.text.trim(),
          description: descriptionController.text.trim(),
        );
        Get.snackbar('Success', 'Store updated successfully',
            backgroundColor: Colors.green, colorText: Colors.white);
      }
      
      currentStore.value = savedStore;
    } catch (e) {
      Get.snackbar('Error', e.toString().replaceAll('Exception: ', ''),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isSaving.value = false;
    }
  }
}
