import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../controllers/address_controller.dart';

class AddressFormView extends GetView<AddressController> {
  const AddressFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          controller.isEditing ? 'Edit Address' : 'Add Address',
          style: AppTextStyles.heading4.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CustomTextField(
              label: 'Label',
              hint: 'E.g., Home, Office',
              controller: controller.labelController,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Recipient Name',
              hint: 'Full name',
              controller: controller.recipientNameController,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Phone Number',
              hint: '08xxxxxxxxxx',
              controller: controller.phoneController,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Full Address',
              hint: 'Street name, building, house no.',
              controller: controller.fullAddressController,
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'City',
              hint: 'City name',
              controller: controller.cityController,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Postal Code',
              hint: '12345',
              controller: controller.postalCodeController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            Obx(() => CheckboxListTile(
                  value: controller.isDefault.value,
                  onChanged: (val) => controller.isDefault.value = val ?? false,
                  title: const Text('Set as default address'),
                  activeColor: AppColors.primary,
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                )),
            const SizedBox(height: 24),
            Obx(() => CustomButton(
                  text: controller.isEditing ? 'Update' : 'Save',
                  width: double.infinity,
                  size: ButtonSize.large,
                  isLoading: controller.isSaving.value,
                  onPressed: controller.saveAddress,
                )),
          ],
        ),
      ),
    );
  }
}
