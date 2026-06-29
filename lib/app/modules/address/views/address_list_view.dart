import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_dialog.dart';
import '../controllers/address_controller.dart';

class AddressListView extends GetView<AddressController> {
  const AddressListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Shipping Address',
          style: AppTextStyles.heading4.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.addresses.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.location_off,
                  size: 64,
                  color: AppColors.grey300,
                ),
                const SizedBox(height: 16),
                Text('No address yet', style: AppTextStyles.heading4),
                const SizedBox(height: 8),
                Text(
                  'Add a shipping address for checkout',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: 'Add Address',
                  icon: const Icon(Icons.add, color: Colors.white, size: 18),
                  onPressed: () {
                    controller.clearForm();
                    Get.toNamed('/address-form');
                  },
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchAddresses,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.addresses.length,
            itemBuilder: (context, index) {
              final address = controller.addresses[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Material(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: () => Get.back(result: address),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: address.isDefault
                              ? AppColors.primary
                              : AppColors.grey200,
                          width: address.isDefault ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                address.label,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              if (address.isDefault) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'Default',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'edit') {
                              controller.prepareEdit(address);
                              Get.toNamed('/address-form');
                            } else if (value == 'delete') {
                              _confirmDelete(address.id);
                            }
                          },
                          itemBuilder: (_) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Text('Edit'),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Text(
                                'Delete',
                                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      address.recipientName,
                      style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      address.phone,
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${address.fullAddress}, ${address.city} ${address.postalCode}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
            },
          ),
        );
      }),
      floatingActionButton: Obx(() {
        if (controller.addresses.isEmpty) return const SizedBox.shrink();
        return FloatingActionButton(
          onPressed: () {
            controller.clearForm();
            Get.toNamed('/address-form');
          },
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.add, color: Colors.white),
        );
      }),
    );
  }

  void _confirmDelete(String id) {
    Get.dialog(
      CustomDialog(
        title: 'Delete Address',
        content: const Text('Are you sure you want to delete this address?'),
        textConfirm: 'Delete',
        textCancel: 'Cancel',
        confirmColor: AppColors.error,
        onConfirm: () {
          Get.back();
          controller.deleteAddress(id);
        },
      ),
    );
  }
}
