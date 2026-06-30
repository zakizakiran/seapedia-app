import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

import '../../../../routes/app_pages.dart';
import '../../controllers/admin_dashboard_controller.dart';

class AdminDiscountTab extends GetView<AdminDashboardController> {
  const AdminDiscountTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return RefreshIndicator(
        onRefresh: controller.fetchDiscounts,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildList(
                title: 'Vouchers',
                items: controller.vouchers,
                isVoucher: true,
              ),
              const SizedBox(height: 32),
              _buildList(
                title: 'Promos',
                items: controller.promos,
                isVoucher: false,
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildList({
    required String title,
    required List<dynamic> items,
    required bool isVoucher,
  }) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: AppTextStyles.heading5),
            ElevatedButton.icon(
              icon: const Icon(Icons.add, size: 16),
              label: Text(isVoucher ? 'Create Voucher' : 'Create Promo'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isVoucher ? AppColors.primary : Colors.pink,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                minimumSize: const Size(0, 36),
                elevation: 0,
              ),
              onPressed: () => Get.toNamed(
                Routes.ADMIN_CREATE_DISCOUNT,
                arguments: {'isVoucher': isVoucher},
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (items.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.grey200),
            ),
            child: const Center(
              child: Text(
                'No data available',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = items[index];
              final expiry = DateTime.parse(item['expiryDate']);
              final isExpired = expiry.isBefore(DateTime.now());

              String discountStr = '';
              if (item['discountAmount'] != null) {
                discountStr = currencyFormatter.format(item['discountAmount']);
              } else if (item['discountPercent'] != null) {
                discountStr = '${item['discountPercent']}%';
              }

              final Color accentColor = isExpired
                  ? AppColors.grey400
                  : (isVoucher ? AppColors.primary : Colors.pink);

              return Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.grey200),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          isVoucher ? Icons.card_giftcard : Icons.local_offer,
                          color: accentColor,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item['code'],
                                    style: AppTextStyles.bodyLarge.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: isExpired
                                          ? AppColors.textSecondary
                                          : AppColors.textPrimary,
                                      decoration: isExpired
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isExpired
                                        ? Colors.red.withValues(alpha: 0.1)
                                        : Colors.green.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    isExpired ? 'Expired' : 'Active',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: isExpired
                                          ? Colors.red
                                          : Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Discount: $discountStr',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (isVoucher) ...[
                              const SizedBox(height: 4),
                              Text(
                                'Usage: ${item['remainingUsage'] ?? 0}',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: (item['remainingUsage'] ?? 0) == 0
                                      ? AppColors.error
                                      : AppColors.grey600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time_filled,
                                  size: 14,
                                  color: isExpired
                                      ? AppColors.error
                                      : AppColors.grey500,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    DateFormat('dd MMM yyyy').format(expiry),
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: isExpired
                                          ? AppColors.error
                                          : AppColors.grey600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
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
      ],
    );
  }
}
