import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';
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
        title: const Text('My cart', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Obx(() {
        if (controller.cartItems.isEmpty) {
          return const Center(
            child: Text('Your cart is empty', style: AppTextStyles.heading3),
          );
        }
        
        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: controller.cartItems.length,
                separatorBuilder: (context, index) => const Divider(height: 32, color: AppColors.grey200),
                itemBuilder: (context, index) {
                  final item = controller.cartItems[index];
                  final product = item.product;
                  
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.grey200),
                          image: DecorationImage(
                            image: NetworkImage(product.imageUrl),
                            fit: BoxFit.contain,
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
                                    style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => controller.removeItem(index),
                                  child: const Icon(Icons.close, color: AppColors.grey400, size: 20),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            if (item.selectedVariation != null)
                              Text(
                                item.selectedVariation!,
                                style: const TextStyle(color: AppColors.grey500, fontSize: 12),
                              ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: AppTextStyles.heading3.copyWith(fontWeight: FontWeight.bold),
                                ),
                                Container(
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
                                        item.quantity.toString(),
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
                                ),
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
            
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    offset: const Offset(0, -4),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: controller.isPromoApplied.value ? AppColors.primary : AppColors.grey300,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          controller.isPromoApplied.value ? controller.promoCode.value : 'Promo code',
                          style: TextStyle(
                            color: controller.isPromoApplied.value ? AppColors.textPrimary : AppColors.grey500,
                            fontWeight: controller.isPromoApplied.value ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        if (controller.isPromoApplied.value)
                          Row(
                            children: [
                              const Text('Promocode applied', style: TextStyle(color: AppColors.primary, fontSize: 12)),
                              const SizedBox(width: 4),
                              const Icon(Icons.check_circle, color: AppColors.primary, size: 16),
                            ],
                          )
                        else
                          CustomButton(
                            text: 'Apply',
                            size: ButtonSize.small,
                            onPressed: () => controller.applyPromoCode('ADJ3AK'),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Subtotal:', style: TextStyle(color: AppColors.grey500)),
                      Text('\$${controller.subtotal.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Delivery Fee:', style: TextStyle(color: AppColors.grey500)),
                      Text('\$${controller.deliveryFee.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Discount:', style: TextStyle(color: AppColors.grey500)),
                      Text(controller.isPromoApplied.value ? '40%' : '0%', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  CustomButton(
                    text: 'Checkout for \$${controller.total.toStringAsFixed(2)}',
                    size: ButtonSize.large,
                    onPressed: controller.checkout,
                    width: double.infinity,
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
