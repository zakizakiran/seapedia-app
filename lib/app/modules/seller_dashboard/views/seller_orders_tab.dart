import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../controllers/seller_orders_controller.dart';

class SellerOrdersTab extends StatelessWidget {
  const SellerOrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SellerOrdersController>(
      init: SellerOrdersController(),
      builder: (controller) {
        return Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.orders.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.inbox,
                        size: 64,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'No incoming orders',
                      style: AppTextStyles.heading3,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Orders from buyers will appear here',
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey600),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: controller.fetchOrders,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.orders.length,
              itemBuilder: (context, index) {
                final order = controller.orders[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
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
                                const Icon(
                                  Icons.receipt_long,
                                  size: 16,
                                  color: AppColors.grey500,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Order #${order.id.length > 8 ? order.id.substring(0, 8) : order.id}',
                                    style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: _buildStatusBadge(order.status),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      ...order.items.map((item) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    width: 56,
                                    height: 56,
                                    color: AppColors.grey100,
                                    child: item.productImage.isNotEmpty
                                        ? Image.network(
                                            item.productImage,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, _, _) => const Icon(
                                              Icons.image,
                                              color: AppColors.grey300,
                                            ),
                                          )
                                        : const Icon(
                                            Icons.image,
                                            color: AppColors.grey300,
                                          ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.productName,
                                        style: AppTextStyles.bodyMedium.copyWith(
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${item.quantity}x Rp ${_formatCurrency(item.price > 0 ? item.price : order.totalAmount / order.items.length)}',
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getShippingLabel(order.shippingMethod),
                                style: AppTextStyles.caption,
                              ),
                              if (order.createdAt != null)
                                Text(
                                  _formatDate(order.createdAt!),
                                  style: AppTextStyles.caption,
                                ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Total Income',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Text(
                                'Rp ${_formatCurrency(order.totalAmount)}',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (order.status == 'PACKING' || order.status == 'SEDANG_DIKEMAS') ...[
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: CustomButton(
                            onPressed: () => controller.processOrder(order.id),
                            text: 'Process Order',
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          );
        });
      },
    );
  }

  Widget _buildStatusBadge(String status) {
    final color = _getStatusColor(status);
    final label = _getStatusLabel(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
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
        return 'Waiting for Driver';
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

  String _getShippingLabel(String method) {
    switch (method) {
      case 'INSTANT':
        return 'Instant Shipping';
      case 'NEXT_DAY':
        return 'Next Day Shipping';
      case 'REGULAR':
        return 'Regular Shipping';
      default:
        return method;
    }
  }

  String _formatCurrency(double amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
