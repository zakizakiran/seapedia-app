import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../data/models/product_model.dart';
import '../../../data/services/favorites_service.dart';
import '../controllers/product_detail_controller.dart';

class ProductDetailView extends StatelessWidget {
  const ProductDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final argumentProduct = Get.arguments as ProductModel;

    return GetBuilder<ProductDetailController>(
      init: ProductDetailController(),
      tag: argumentProduct.id,
      builder: (controller) {
        final product = controller.product;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            actions: [
              Obx(() {
                final favoritesService = Get.find<FavoritesService>();
                final isFavorite = favoritesService.isFavorite(product.id);
                return IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : AppColors.textPrimary,
                  ),
                  onPressed: () {
                    favoritesService.toggleFavorite(product);
                  },
                );
              }),
              IconButton(
                icon: const Icon(Icons.share_outlined),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    image: product.imageUrl.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(product.imageUrl),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: product.imageUrl.isEmpty
                      ? const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 64,
                            color: AppColors.grey300,
                          ),
                        )
                      : null,
                ),
                const SizedBox(height: 24),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              product.title,
                              style: AppTextStyles.heading2,
                            ),
                          ),
                          if (product.isOnSale)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '% On sale',
                                style: AppTextStyles.caption.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),



                      Text(
                        product.description,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.grey500,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),

                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.grey50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.grey200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.store,
                                    color: AppColors.white,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Sold by',
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: AppColors.grey600,
                                        ),
                                      ),
                                      Text(
                                        product.storeName.isNotEmpty
                                            ? product.storeName
                                            : 'Unknown Store',
                                        style: AppTextStyles.heading4,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            CustomButton(
                              type: ButtonType.outline,
                              text: 'Visit Store',
                              onPressed: () {
                                if (product.storeId.isNotEmpty) {
                                  Get.toNamed(
                                    '/store-detail',
                                    arguments: product.storeId,
                                  );
                                } else {
                                  Get.snackbar(
                                    'Error',
                                    'Store information not available',
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      if (product.variations.isNotEmpty) ...[
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: product.variations.map((variation) {
                            return Obx(() {
                              final isSelected =
                                  controller.selectedVariation.value ==
                                  variation;
                              return GestureDetector(
                                onTap: () =>
                                    controller.selectVariation(variation),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.primary
                                          : AppColors.grey300,
                                      width: 2,
                                    ),
                                  ),
                                  child: Text(
                                    variation,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            });
                          }).toList(),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  offset: const Offset(0, -4),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (product.originalPrice != null)
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Rp ${_formatCurrency(product.originalPrice!)}',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.grey400,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Rp ${_formatCurrency(product.price)}',
                          style: AppTextStyles.heading3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.grey200),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: controller.decrementQuantity,
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(8),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.remove,
                            size: 20,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      Obx(
                        () => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text(
                            '${controller.quantity.value}',
                            style: AppTextStyles.heading6,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: controller.incrementQuantity,
                        borderRadius: const BorderRadius.horizontal(
                          right: Radius.circular(8),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.add,
                            size: 20,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.shopping_cart_checkout_rounded,
                      color: Colors.white,
                    ),
                    onPressed: controller.addToCart,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatCurrency(double amount) {
    return amount
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]}.',
        );
  }
}
