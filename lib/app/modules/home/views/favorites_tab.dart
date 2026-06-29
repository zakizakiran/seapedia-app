import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/product_card.dart';
import '../controllers/favorites_controller.dart';

class FavoritesTab extends StatelessWidget {
  const FavoritesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FavoritesController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Favorites', style: AppTextStyles.heading3),
        centerTitle: false,
      ),
      body: Obx(() {
        if (!controller.hasFavorites) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.favorite_border, size: 80, color: AppColors.grey400),
                const SizedBox(height: 16),
                Text(
                  'No favorites yet',
                  style: AppTextStyles.heading5,
                ),
                const SizedBox(height: 8),
                Text(
                  'Items you favorite will appear here.',
                  style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: controller.favoriteProducts.length,
          itemBuilder: (context, index) {
            final product = controller.favoriteProducts[index];
            return ProductCard(
              product: product,
              onTap: () => controller.navigateToProductDetail(product),
            );
          },
        );
      }),
    );
  }
}
