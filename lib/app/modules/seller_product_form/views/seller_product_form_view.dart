import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../controllers/seller_product_form_controller.dart';

class SellerProductFormView extends GetView<SellerProductFormController> {
  const SellerProductFormView({super.key});

  @override
  Widget build(BuildContext context) {
    final isEditing = controller.editingProduct != null;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Product' : 'Add Product', style: AppTextStyles.heading3),
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                controller: controller.titleController,
                label: 'Product Name',
                hint: 'e.g. Ikan Salmon Segar',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Product name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: controller.descriptionController,
                label: 'Description',
                hint: 'Describe your product...',
                type: TextFieldType.textarea,
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: controller.priceController,
                label: 'Price (Rp)',
                hint: '0',
                type: TextFieldType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Price is required';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Invalid price format';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: controller.stockController,
                label: 'Stock Quantity',
                hint: '0',
                type: TextFieldType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Stock is required';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Invalid stock format';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: controller.imageUrlController,
                label: 'Image URL (Optional)',
                hint: 'https://example.com/image.jpg',
                type: TextFieldType.text,
              ),
              const SizedBox(height: 32),
              Obx(() => CustomButton(
                    text: isEditing ? 'Save Changes' : 'Add Product',
                    isLoading: controller.isLoading.value,
                    onPressed: controller.saveProduct,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
