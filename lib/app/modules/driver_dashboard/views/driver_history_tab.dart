import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controllers/driver_dashboard_controller.dart';

class DriverHistoryTab extends GetView<DriverDashboardController> {
  const DriverHistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.jobHistory.isEmpty) {
        return RefreshIndicator(
          onRefresh: controller.fetchDashboard,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.history, size: 64, color: AppColors.grey400),
                      const SizedBox(height: 16),
                      Text(
                        'No Job History',
                        style: AppTextStyles.heading5.copyWith(color: AppColors.grey800),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'You haven\'t completed any deliveries yet.',
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey600),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }

      final currencyFormatter = NumberFormat.currency(
        locale: 'id_ID',
        symbol: 'Rp ',
        decimalDigits: 0,
      );

      return RefreshIndicator(
        onRefresh: controller.fetchDashboard,
        child: ListView.separated(
          padding: const EdgeInsets.all(24),
          itemCount: controller.jobHistory.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final job = controller.jobHistory[index];
            final order = job['order'] ?? {};

            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.grey200),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      color: AppColors.success,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order #${order['id']?.substring(0, 8).toUpperCase() ?? ''}',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Earned: ${currencyFormatter.format(job['earnings'] ?? 0)}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.success,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    });
  }
}
