import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_dialog.dart';
import '../controllers/cart_controller.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Cart',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          Obx(() {
            if (controller.cartItems.isEmpty) return const SizedBox.shrink();
            return IconButton(
              icon: const Icon(Icons.delete_outline, color: AppColors.error),
              onPressed: _confirmClear,
            );
          }),
          const SizedBox(width: 8),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.cartItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.shopping_cart_outlined,
                  size: 80,
                  color: AppColors.grey300,
                ),
                const SizedBox(height: 16),
                Text('Cart is empty', style: AppTextStyles.heading4),
                const SizedBox(height: 8),
                const Text(
                  'Let\'s start shopping!',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: 'Shop Now',
                  onPressed: () => Get.offAllNamed('/home'),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            _buildStoreHeader(),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: controller.cartItems.length,
                separatorBuilder: (_, _) =>
                    const Divider(height: 32, color: AppColors.grey200),
                itemBuilder: (context, index) {
                  final item = controller.cartItems[index];
                  final product = item.product;

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: 80,
                          height: 80,
                          color: AppColors.grey100,
                          child: product.imageUrl.isNotEmpty
                              ? Image.network(
                                  product.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) => const Icon(
                                    Icons.image_not_supported,
                                    color: AppColors.grey300,
                                  ),
                                )
                              : const Icon(
                                  Icons.image_not_supported,
                                  color: AppColors.grey300,
                                ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    product.title,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => controller.removeItem(index),
                                  child: const Icon(
                                    Icons.close,
                                    color: AppColors.grey400,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            if (item.selectedVariation != null)
                              Text(
                                item.selectedVariation!,
                                style: const TextStyle(
                                  color: AppColors.grey500,
                                  fontSize: 12,
                                ),
                              ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Rp ${_formatCurrency(product.price)}',
                                  style: AppTextStyles.heading4.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                _buildQuantityControl(index, item.quantity),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            _buildCheckoutBar(),
          ],
        );
      }),
    );
  }

  Widget _buildStoreHeader() {
    return Obx(() {
      if (controller.currentStoreName.value.isEmpty) {
        return const SizedBox.shrink();
      }
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        color: AppColors.primary.withValues(alpha: 0.08),
        child: Row(
          children: [
            const Icon(Icons.store, size: 18, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(
              controller.currentStoreName.value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            const Spacer(),
            Text(
              'Single-store cart',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.primary.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildQuantityControl(int index, int quantity) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grey300),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => controller.decrementQuantity(index),
            icon: const Icon(Icons.remove, size: 16),
            padding: const EdgeInsets.all(4),
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
          Text(
            quantity.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          IconButton(
            onPressed: () => controller.incrementQuantity(index),
            icon: const Icon(Icons.add, size: 16, color: AppColors.primary),
            padding: const EdgeInsets.all(4),
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutBar() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, -4),
            blurRadius: 10,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  Obx(() => Text(
                        'Rp ${_formatCurrency(controller.subtotal)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      )),
                ],
              ),
            ),
            Expanded(
              child: CustomButton(
                text: 'Checkout',
                size: ButtonSize.large,
                onPressed: controller.goToCheckout,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmClear() {
    Get.dialog(
      CustomDialog(
        title: 'Clear Cart',
        content: const Text('Are you sure you want to remove all items from the cart?'),
        textConfirm: 'Remove',
        textCancel: 'Cancel',
        confirmColor: AppColors.error,
        onConfirm: () {
          Get.back();
          controller.clearCart();
        },
      ),
    );
  }

  String _formatCurrency(double amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    );
  }
}
