import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.inbox,
                    size: 64,
                    color: AppColors.grey300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada pesanan masuk',
                    style: AppTextStyles.heading4,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Pesanan dari buyer akan muncul di sini',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ],
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
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.grey200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Order #${order.id.length > 8 ? order.id.substring(0, 8) : order.id}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          _buildStatusBadge(order.status),
                        ],
                      ),
                      const Divider(height: 20),
                      ...order.items.map((item) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    '${item.productName} x${item.quantity}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  'Rp ${_formatCurrency(item.subtotal)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          )),
                      const Divider(height: 20),
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
                          Text(
                            'Rp ${_formatCurrency(order.totalAmount)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
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
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'SEDANG_DIKEMAS':
        return AppColors.statusPacking;
      case 'MENUNGGU_PENGIRIM':
        return AppColors.statusWaitingDriver;
      case 'SEDANG_DIKIRIM':
        return AppColors.statusDelivering;
      case 'PESANAN_SELESAI':
        return AppColors.statusCompleted;
      case 'DIKEMBALIKAN':
        return AppColors.statusReturned;
      default:
        return AppColors.grey500;
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'SEDANG_DIKEMAS':
        return 'Sedang Dikemas';
      case 'MENUNGGU_PENGIRIM':
        return 'Menunggu Pengirim';
      case 'SEDANG_DIKIRIM':
        return 'Sedang Dikirim';
      case 'PESANAN_SELESAI':
        return 'Selesai';
      case 'DIKEMBALIKAN':
        return 'Dikembalikan';
      default:
        return status;
    }
  }

  String _getShippingLabel(String method) {
    switch (method) {
      case 'INSTANT':
        return 'Pengiriman Instant';
      case 'NEXT_DAY':
        return 'Pengiriman Next Day';
      case 'REGULAR':
        return 'Pengiriman Regular';
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
