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
                        fit: BoxFit.contain,
                      )
                    : null,
              ),
              child: product.imageUrl.isEmpty
                  ? const Center(
                      child: Icon(Icons.image_not_supported, size: 64, color: AppColors.grey300),
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
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            '% On sale',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        product.rating.toStringAsFixed(1),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.thumb_up, color: AppColors.primary, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        '${product.positiveReviewPercentage}%',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '${product.reviewCount} reviews',
                        style: const TextStyle(color: AppColors.grey500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  Text(
                    product.description,
                    style: const TextStyle(color: AppColors.grey500, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  
                  // Store Info
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.grey50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.grey200),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.store, color: AppColors.white),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sold by',
                                style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey600),
                              ),
                              Text(
                                product.storeName.isNotEmpty ? product.storeName : 'Unknown Store',
                                style: AppTextStyles.heading4,
                              ),
                            ],
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            if (product.storeId.isNotEmpty) {
                              Get.toNamed('/store-detail', arguments: product.storeId);
                            } else {
                              Get.snackbar('Error', 'Store information not available');
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(color: AppColors.primary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Visit Store'),
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
                          final isSelected = controller.selectedVariation.value == variation;
                          return GestureDetector(
                            onTap: () => controller.selectVariation(variation),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected ? AppColors.primary : AppColors.grey300,
                                  width: 2,
                                ),
                              ),
                              child: Text(
                                variation,
                                style: TextStyle(
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
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (product.originalPrice != null)
                  Text(
                    '\$${product.originalPrice!.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: AppColors.grey400,
                      decoration: TextDecoration.lineThrough,
                      fontSize: 14,
                    ),
                  ),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 32),
            Expanded(
              child: CustomButton(
                text: 'Add to Cart',
                size: ButtonSize.large,
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
}
