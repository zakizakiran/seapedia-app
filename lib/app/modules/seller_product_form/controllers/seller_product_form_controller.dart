import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/product_model.dart';
import '../../../data/providers/product_provider.dart';

class SellerProductFormController extends GetxController {
  final ProductProvider _productProvider = ProductProvider();
  
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();
  final imageUrlController = TextEditingController();

  final RxBool isLoading = false.obs;
  ProductModel? editingProduct;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is ProductModel) {
      editingProduct = Get.arguments as ProductModel;
      titleController.text = editingProduct!.title;
      descriptionController.text = editingProduct!.description;
      priceController.text = editingProduct!.price.toInt().toString();
      stockController.text = editingProduct!.stock.toString();
      imageUrlController.text = editingProduct!.imageUrl;
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    stockController.dispose();
    imageUrlController.dispose();
    super.onClose();
  }

  Future<void> saveProduct() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading.value = true;
      final name = titleController.text.trim();
      final description = descriptionController.text.trim();
      final price = double.parse(priceController.text.trim());
      final stock = int.parse(stockController.text.trim());
      final imageUrl = imageUrlController.text.trim();

      if (editingProduct == null) {
        // Create
        await _productProvider.createProduct(
          name: name,
          description: description,
          price: price,
          stock: stock,
          imageUrl: imageUrl,
        );
        Get.snackbar('Success', 'Product created successfully',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        // Update
        await _productProvider.updateProduct(
          id: editingProduct!.id,
          name: name,
          description: description,
          price: price,
          stock: stock,
          imageUrl: imageUrl,
        );
        Get.snackbar('Success', 'Product updated successfully',
            backgroundColor: Colors.green, colorText: Colors.white);
      }
      
      Get.back(result: true); // Return to previous screen and trigger refresh
    } catch (e) {
      Get.snackbar('Error', e.toString().replaceAll('Exception: ', ''),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}
