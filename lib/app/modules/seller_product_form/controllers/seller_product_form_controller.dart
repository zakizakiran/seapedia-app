import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/custom_dialog.dart';
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

  final List<String> categories = [
    'Gadget',
    'Fashion',
    'Beauty',
    'Food',
    'Home',
  ];
  final RxString selectedCategory = 'Gadget'.obs;

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
      if (categories.contains(editingProduct!.category)) {
        selectedCategory.value = editingProduct!.category;
      }
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
          category: selectedCategory.value,
        );
        Get.back(result: true);
        Get.dialog(
          CustomDialog(
            title: 'Success',
            content: const Text('Product created successfully.'),
            textConfirm: 'OK',
            showCancelButton: false,
            onConfirm: () {
              Get.back();
            },
          ),
        );
      } else {
        // Update
        await _productProvider.updateProduct(
          id: editingProduct!.id,
          name: name,
          description: description,
          price: price,
          stock: stock,
          imageUrl: imageUrl,
          category: selectedCategory.value,
        );
        Get.back(result: true);
        Get.dialog(
          CustomDialog(
            title: 'Success',
            content: const Text('Product updated successfully.'),
            textConfirm: 'OK',
            showCancelButton: false,
            onConfirm: () {
              Get.back();
            },
          ),
        );
      }
    } catch (e) {
      Get.dialog(
        CustomDialog(
          title: 'Error',
          content: Text(e.toString().replaceAll('Exception: ', '')),
          textConfirm: 'OK',
          showCancelButton: false,
          confirmColor: Colors.red,
          onConfirm: () {
            Get.back();
          },
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
