import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../controllers/store_profile_controller.dart';

class StoreProfileTab extends GetView<StoreProfileController> {
  const StoreProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator(color: AppColors.primary));
      }

      final hasStore = controller.currentStore.value != null;

      return SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              hasStore ? 'Manage Store' : 'Create Your Store',
              style: AppTextStyles.heading2,
            ),
            const SizedBox(height: 8),
            Text(
              hasStore 
                  ? 'Update your store details below.'
                  : 'You need to create a store before you can add products.',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey600),
            ),
            const SizedBox(height: 32),
            Form(
              key: controller.formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: controller.nameController,
                    label: 'Store Name',
                    hint: 'Enter your store name',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Store name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: controller.descriptionController,
                    label: 'Description',
                    hint: 'What is your store about?',
                    type: TextFieldType.textarea,
                    maxLines: 4,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: hasStore ? 'Update Store' : 'Create Store',
                      isLoading: controller.isSaving.value,
                      onPressed: controller.saveStore,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
