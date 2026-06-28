import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../controllers/my_products_controller.dart';
import '../controllers/store_profile_controller.dart';

class MyProductsTab extends GetView<MyProductsController> {
  const MyProductsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final storeController = Get.find<StoreProfileController>();

    return Obx(() {
      if (storeController.currentStore.value == null) {
        return _buildEmptyStoreState();
      }

      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('My Products', style: AppTextStyles.heading3),
                CustomButton(
                  text: 'Add Product',
                  icon: const Icon(Icons.add),
                  onPressed: controller.navigateToAddProduct,
                ),
              ],
            ),
          ),
          Expanded(
            child: controller.isLoading.value && controller.products.isEmpty
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : controller.products.isEmpty
                    ? _buildEmptyProductsState()
                    : RefreshIndicator(
                        onRefresh: controller.loadProducts,
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          itemCount: controller.products.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final product = controller.products[index];
                            final currencyFormatter = NumberFormat.currency(
                              locale: 'id_ID',
                              symbol: 'Rp ',
                              decimalDigits: 0,
                            );
                            
                            return Container(
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.grey200),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  // Product Image
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: AppColors.grey100,
                                      borderRadius: BorderRadius.circular(12),
                                      image: product.imageUrl.isNotEmpty
                                          ? DecorationImage(
                                              image: NetworkImage(product.imageUrl),
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                    ),
                                    child: product.imageUrl.isEmpty
                                        ? const Icon(Icons.inventory_2, color: AppColors.grey400)
                                        : null,
                                  ),
                                  const SizedBox(width: 16),
                                  // Details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.title,
                                          style: AppTextStyles.heading4,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          currencyFormatter.format(product.price),
                                          style: AppTextStyles.bodyLarge.copyWith(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Stock: ${product.stock}',
                                          style: AppTextStyles.bodySmall.copyWith(
                                            color: AppColors.grey600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Actions
                                  Column(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: AppColors.primary),
                                        onPressed: () => controller.navigateToEditProduct(product),
                                        tooltip: 'Edit Product',
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: AppColors.error),
                                        onPressed: () => controller.confirmDeleteProduct(product.id),
                                        tooltip: 'Delete Product',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      );
    });
  }

  Widget _buildEmptyStoreState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.store_mall_directory, size: 80, color: AppColors.grey300),
            const SizedBox(height: 16),
            Text(
              'No Store Profile',
              style: AppTextStyles.heading3,
            ),
            const SizedBox(height: 8),
            Text(
              'You must create your store profile first before adding products.',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyProductsState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory, size: 80, color: AppColors.grey300),
            const SizedBox(height: 16),
            Text(
              'No Products Yet',
              style: AppTextStyles.heading3,
            ),
            const SizedBox(height: 8),
            Text(
              'Start adding products to your store to sell them on Seapedia.',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
