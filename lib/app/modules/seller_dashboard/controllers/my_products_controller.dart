import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/product_model.dart';
import '../../../data/providers/product_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_dialog.dart';
import 'store_profile_controller.dart';

class MyProductsController extends GetxController {
  final ProductProvider _productProvider = ProductProvider();
  
  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Only load products if the store is already created
    final storeProfileController = Get.find<StoreProfileController>();
    if (storeProfileController.currentStore.value != null) {
      loadProducts();
    }
  }

  Future<void> loadProducts() async {
    try {
      isLoading.value = true;
      final data = await _productProvider.getSellerProducts();
      products.assignAll(data);
    } catch (e) {
      Get.snackbar('Error', e.toString().replaceAll('Exception: ', ''),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToAddProduct() {
    final storeProfileController = Get.find<StoreProfileController>();
    if (storeProfileController.currentStore.value == null) {
      Get.snackbar('Error', 'Please create a store profile first',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    Get.toNamed('/seller-product-form')?.then((_) => loadProducts());
  }

  void navigateToEditProduct(ProductModel product) {
    Get.toNamed('/seller-product-form', arguments: product)?.then((_) => loadProducts());
  }

  void confirmDeleteProduct(String id) {
    Get.dialog(
      CustomDialog(
        title: 'Delete Product',
        content: const Text('Are you sure you want to delete this product?'),
        textConfirm: 'Delete',
        textCancel: 'Cancel',
        confirmColor: AppColors.error,
        onConfirm: () {
          Get.back();
          _deleteProduct(id);
        },
      ),
    );
  }

  Future<void> _deleteProduct(String id) async {
    try {
      isLoading.value = true;
      await _productProvider.deleteProduct(id);
      Get.snackbar('Success', 'Product deleted successfully',
          backgroundColor: Colors.green, colorText: Colors.white);
      await loadProducts();
    } catch (e) {
      Get.snackbar('Error', e.toString().replaceAll('Exception: ', ''),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}
