import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controllers/order_controller.dart';

class OrderListView extends GetView<OrderController> {
  const OrderListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'My Orders',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final orders = controller.filteredOrders;
              if (orders.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.receipt_long,
                        size: 64,
                        color: AppColors.grey300,
                      ),
                      const SizedBox(height: 16),
                      Text('No orders yet', style: AppTextStyles.heading4),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.fetchOrders,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return GestureDetector(
                      onTap: () {
                        controller.fetchOrderDetail(order.id);
                        Get.toNamed(
                          '/order-detail',
                          arguments: order.id,
                        );
                      },
                      child: Container(
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
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.store,
                                      size: 16,
                                      color: AppColors.grey500,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      order.storeName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                _buildStatusBadge(order.status),
                              ],
                            ),
                            const Divider(height: 24),
                            ...order.items.take(2).map((item) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Container(
                                          width: 48,
                                          height: 48,
                                          color: AppColors.grey100,
                                          child: item.productImage.isNotEmpty
                                              ? Image.network(
                                                  item.productImage,
                                                  fit: BoxFit.cover,
                                                  errorBuilder:
                                                      (_, __, ___) =>
                                                          const Icon(
                                                    Icons.image,
                                                    color: AppColors.grey300,
                                                    size: 20,
                                                  ),
                                                )
                                              : const Icon(
                                                  Icons.image,
                                                  color: AppColors.grey300,
                                                  size: 20,
                                                ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          item.productName,
                                          style: const TextStyle(fontSize: 14),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        'x${item.quantity}',
                                        style: const TextStyle(
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            if (order.items.length > 2)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  '+${order.items.length - 2} other products',
                                  style: AppTextStyles.caption,
                                ),
                              ),
                            const Divider(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${order.items.fold(0, (sum, i) => sum + i.quantity)} item',
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                  ),
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
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Obx(() => Row(
            children: controller.filters.map((f) {
              final isSelected = controller.selectedFilter.value == f['key'];
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  selected: isSelected,
                  label: Text(f['label']!),
                  selectedColor: AppColors.primary.withValues(alpha: 0.15),
                  checkmarkColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color:
                        isSelected ? AppColors.primary : AppColors.textSecondary,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                  onSelected: (_) => controller.setFilter(f['key']!),
                ),
              );
            }).toList(),
          )),
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
        return 'Packing';
      case 'MENUNGGU_PENGIRIM':
        return 'Waiting for Courier';
      case 'SEDANG_DIKIRIM':
        return 'Delivering';
      case 'PESANAN_SELESAI':
        return 'Completed';
      case 'DIKEMBALIKAN':
        return 'Returned';
      default:
        return status;
    }
  }

  String _formatCurrency(double amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    );
  }
}
