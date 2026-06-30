import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controllers/admin_products_controller.dart';
import '../../../core/utils/string_extensions.dart';
import '../../../core/utils/num_extensions.dart';
import '../../../core/widgets/custom_text_field.dart';


class AdminProductsView extends GetView<AdminProductsController> {
  const AdminProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Admin Products', style: AppTextStyles.heading5),
        backgroundColor: AppColors.white,
      ),
      body: Obx(() {
        if (controller.isLoading.value) return const Center(child: CircularProgressIndicator());
        if (controller.filteredItems.isEmpty && controller.searchQuery.value.isEmpty) return const Center(child: Text('No data available'));
        
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: CustomTextField(
                hint: 'Search',
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                onChanged: controller.onSearch,
              ),
            ),
            Expanded(
              child: controller.filteredItems.isEmpty
                  ? const Center(child: Text('No results found'))
                  : ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: controller.filteredItems.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = controller.filteredItems[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.grey200),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: (item['imageUrl'] != null && item['imageUrl'].toString().isNotEmpty)
                          ? Image.network(
                              item['imageUrl'].toString(),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.inventory_2, color: AppColors.primary),
                            )
                          : const Icon(Icons.inventory_2, color: AppColors.primary),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  (item['name']?.toString() ?? 'Unknown Product').unescapeHtml,
                                  style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: (item['stock'] != null && item['stock'] > 0)
                                      ? Colors.green.withValues(alpha: 0.1)
                                      : Colors.red.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  (item['stock'] != null && item['stock'] > 0)
                                      ? 'Stock: ${item['stock']}'
                                      : 'Out of Stock',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: (item['stock'] != null && item['stock'] > 0)
                                        ? Colors.green
                                        : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          if (item['store'] != null)
                            Text(
                              'Store: ${(item['store']['name']?.toString() ?? '-').unescapeHtml}',
                              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          const SizedBox(height: 2),
                          Text(
                            (item['category']?.toString() ?? '-').unescapeHtml,
                            style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            num.parse((item['price'] ?? 0).toString()).toRp,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
            ),
            ),
          ],
        );
      }),
    );
  }
}
