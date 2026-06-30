import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controllers/admin_orders_controller.dart';
import '../../../core/utils/string_extensions.dart';
import '../../../core/utils/num_extensions.dart';
import '../../../core/widgets/custom_text_field.dart';


class AdminOrdersView extends GetView<AdminOrdersController> {
  const AdminOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Admin Orders', style: AppTextStyles.heading5),
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
                                  'Order #${(item['id'] ?? '').toString().length > 8 ? (item['id'] ?? '').toString().substring(0, 8) : (item['id'] ?? '')}',
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
                          if (item['buyer'] != null)
                            Text(
                              'Buyer: ${(item['buyer']['name']?.toString() ?? '-').unescapeHtml}',
                              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          const SizedBox(height: 2),
                          if (item['store'] != null)
                            Text(
                              'Store: ${(item['store']['name']?.toString() ?? '-').unescapeHtml}',
                              style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          const SizedBox(height: 6),
                          Text(
                            'Total: ${num.parse((item['totalAmount'] ?? item['total'] ?? 0).toString()).toRp}',
                            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'SEDANG_DIKEMAS':
      case 'PACKING':
        return AppColors.statusPacking;
      case 'MENUNGGU_PENGIRIM':
      case 'WAITING_FOR_DRIVER':
        return AppColors.statusWaitingDriver;
      case 'SEDANG_DIKIRIM':
      case 'DELIVERING':
        return AppColors.statusDelivering;
      case 'PESANAN_SELESAI':
      case 'COMPLETED':
        return AppColors.statusCompleted;
      case 'DIKEMBALIKAN':
      case 'RETURNED':
        return AppColors.statusReturned;
      default:
        return AppColors.grey500;
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'SEDANG_DIKEMAS':
      case 'PACKING':
        return 'Packing';
      case 'MENUNGGU_PENGIRIM':
      case 'WAITING_FOR_DRIVER':
        return 'Waiting Courier';
      case 'SEDANG_DIKIRIM':
      case 'DELIVERING':
        return 'Delivering';
      case 'PESANAN_SELESAI':
      case 'COMPLETED':
        return 'Completed';
      case 'DIKEMBALIKAN':
      case 'RETURNED':
        return 'Returned';
      default:
        return status;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'SEDANG_DIKEMAS':
      case 'PACKING':
        return Icons.inventory;
      case 'MENUNGGU_PENGIRIM':
      case 'WAITING_FOR_DRIVER':
        return Icons.hourglass_top;
      case 'SEDANG_DIKIRIM':
      case 'DELIVERING':
        return Icons.local_shipping;
      case 'PESANAN_SELESAI':
      case 'COMPLETED':
        return Icons.check_circle;
      case 'DIKEMBALIKAN':
      case 'RETURNED':
        return Icons.undo;
      default:
        return Icons.receipt_long;
    }
  }
}
