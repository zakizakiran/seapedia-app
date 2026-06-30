import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controllers/driver_jobs_controller.dart';
import 'package:intl/intl.dart';

class DriverJobsTab extends GetView<DriverJobsController> {
  const DriverJobsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.availableJobs.isEmpty) {
          return RefreshIndicator(
            onRefresh: controller.fetchJobs,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.inbox, size: 64, color: AppColors.grey400),
                      const SizedBox(height: 16),
                      Text(
                        'No Jobs Available',
                        style: AppTextStyles.heading5.copyWith(color: AppColors.grey800),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Check back later for new delivery requests.',
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchJobs,
          child: ListView.separated(
            padding: const EdgeInsets.all(24),
            itemCount: controller.availableJobs.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final job = controller.availableJobs[index];
              final store = job['store'] ?? {};
              final address = job['address'] ?? {};
              
              final currencyFormatter = NumberFormat.currency(
                locale: 'id_ID',
                symbol: 'Rp ',
                decimalDigits: 0,
              );

              final earningEstimate = (job['deliveryFee'] ?? 0) * 0.8;

              return InkWell(
                onTap: () => Get.toNamed('/driver-job-detail', arguments: job['id']),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.grey200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                const Icon(Icons.delivery_dining, size: 16, color: AppColors.primary),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Order #${job['id']?.substring(0, 8).toUpperCase() ?? ''}',
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
                            ),
                            child: Text(
                              'Earn ${currencyFormatter.format(earningEstimate)}',
                              style: const TextStyle(
                                color: AppColors.success,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.store, color: AppColors.grey500, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Pickup',
                                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                ),
                                Text(
                                  store['name'] ?? 'Unknown Store',
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.place, color: AppColors.error, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Dropoff',
                                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                ),
                                Text(
                                  address['recipientName'] ?? 'Unknown Name',
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    const Icon(Icons.phone, size: 12, color: AppColors.textSecondary),
                                    const SizedBox(width: 4),
                                    Text(
                                      address['phoneNumber'] ?? '-',
                                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  address['fullAddress'] ?? 'Unknown Address',
                                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      });
  }
}
