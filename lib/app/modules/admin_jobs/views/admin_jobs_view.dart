import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controllers/admin_jobs_controller.dart';
import '../../../core/utils/string_extensions.dart';
import '../../../core/utils/num_extensions.dart';
import '../../../core/widgets/custom_text_field.dart';


class AdminJobsView extends GetView<AdminJobsController> {
  const AdminJobsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Admin Jobs', style: AppTextStyles.heading5),
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
            final status = item['status']?.toString() ?? 'UNKNOWN';
            final statusColor = _getStatusColor(status);
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
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(_getStatusIcon(status), color: statusColor),
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
                                  'Job #${(item['id'] ?? '').toString().length > 8 ? (item['id'] ?? '').toString().substring(0, 8) : (item['id'] ?? '')}',
                                  style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: statusColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  _getStatusLabel(status),
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: statusColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          if (item['driver'] != null)
                            Text(
                              'Driver: ${(item['driver']['name']?.toString() ?? '-').unescapeHtml}',
                              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          const SizedBox(height: 2),
                          if (item['order'] != null) ...[
                            Text(
                              'Order #${(item['order']['id'] ?? '').toString().length > 8 ? (item['order']['id'] ?? '').toString().substring(0, 8) : (item['order']['id'] ?? '')}',
                              style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Total: ${num.parse((item['order']['totalAmount'] ?? item['order']['total'] ?? 0).toString()).toRp}',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
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

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'ASSIGNED':
      case 'PENDING':
        return AppColors.statusPacking;
      case 'PICKED_UP':
      case 'PICKING_UP':
        return AppColors.statusWaitingDriver;
      case 'DELIVERING':
      case 'ON_THE_WAY':
        return AppColors.statusDelivering;
      case 'DELIVERED':
      case 'COMPLETED':
        return AppColors.statusCompleted;
      case 'CANCELLED':
      case 'FAILED':
        return AppColors.statusReturned;
      default:
        return AppColors.grey500;
    }
  }

  String _getStatusLabel(String status) {
    switch (status.toUpperCase()) {
      case 'ASSIGNED':
        return 'Assigned';
      case 'PENDING':
        return 'Pending';
      case 'PICKED_UP':
      case 'PICKING_UP':
        return 'Picked Up';
      case 'DELIVERING':
      case 'ON_THE_WAY':
        return 'Delivering';
      case 'DELIVERED':
        return 'Delivered';
      case 'COMPLETED':
        return 'Completed';
      case 'CANCELLED':
        return 'Cancelled';
      case 'FAILED':
        return 'Failed';
      default:
        return status;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toUpperCase()) {
      case 'ASSIGNED':
      case 'PENDING':
        return Icons.assignment;
      case 'PICKED_UP':
      case 'PICKING_UP':
        return Icons.inventory;
      case 'DELIVERING':
      case 'ON_THE_WAY':
        return Icons.local_shipping;
      case 'DELIVERED':
      case 'COMPLETED':
        return Icons.check_circle;
      case 'CANCELLED':
      case 'FAILED':
        return Icons.cancel;
      default:
        return Icons.delivery_dining;
    }
  }
}
