import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/order_model.dart';
import '../controllers/order_controller.dart';

class OrderDetailView extends GetView<OrderController> {
  const OrderDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Order Detail',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isDetailLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final order = controller.orderDetail.value;
        if (order == null) {
          return const Center(child: Text('Order not found'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatusHeader(order.status),
              const SizedBox(height: 20),
              _buildStatusTimeline(order.statusHistory),
              const SizedBox(height: 20),
              _buildStoreAndItems(order),
              const SizedBox(height: 20),
              _buildAddressSection(order.deliveryAddress, order.shippingMethod),
              const SizedBox(height: 20),
              _buildPaymentDetail(order),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatusHeader(String status) {
    final color = _getStatusColor(status);
    final label = _getStatusLabel(status);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(_getStatusIcon(status), color: color, size: 32),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Order Status',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTimeline(List statusHistory) {
    if (statusHistory.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Status History', style: AppTextStyles.heading5),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.grey200),
          ),
          child: Column(
            children: List.generate(statusHistory.length, (index) {
              final entry = statusHistory[index];
              final isLast = index == statusHistory.length - 1;
              final color = _getStatusColor(entry.status);

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      if (!isLast)
                        Container(
                          width: 2,
                          height: 40,
                          color: AppColors.grey200,
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getStatusLabel(entry.status),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        if (entry.timestamp != null)
                          Text(
                            _formatDateTime(entry.timestamp!),
                            style: AppTextStyles.caption,
                          ),
                        if (!isLast) const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildStoreAndItems(OrderModel order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Product Detail', style: AppTextStyles.heading5),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
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
                children: [
                  const Icon(Icons.store, size: 18, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    order.storeName,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const Divider(height: 24),
              ...order.items.map<Widget>(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
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
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '${item.quantity}x Rp ${_formatCurrency(item.price)}',
                              style: AppTextStyles.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddressSection(String address, String shippingMethod) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Shipping', style: AppTextStyles.heading5),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
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
                children: [
                  const Icon(
                    Icons.local_shipping,
                    size: 18,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _getShippingLabel(shippingMethod),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const Divider(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 18,
                    color: AppColors.grey500,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      address,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentDetail(OrderModel order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Payment Detail', style: AppTextStyles.heading5),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.grey200),
          ),
          child: Column(
            children: [
              _buildPaymentRow(
                'Subtotal',
                'Rp ${_formatCurrency(order.subtotal)}',
              ),
              const SizedBox(height: 8),
              _buildPaymentRow(
                'Shipping Fee',
                'Rp ${_formatCurrency(order.deliveryFee)}',
              ),
              const SizedBox(height: 8),
              _buildPaymentRow(
                'PPN (12%)',
                'Rp ${_formatCurrency(order.ppnAmount)}',
              ),
              if (order.discountAmount > 0) ...[
                const SizedBox(height: 8),
                _buildPaymentRow(
                  'Discount',
                  '- Rp ${_formatCurrency(order.discountAmount)}',
                  valueColor: AppColors.success,
                ),
              ],
              const Divider(height: 24),
              _buildPaymentRow(
                'Total Payment',
                'Rp ${_formatCurrency(order.totalAmount)}',
                isBold: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentRow(
    String label,
    String value, {
    bool isBold = false,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isBold ? AppColors.textPrimary : AppColors.textSecondary,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            fontSize: isBold ? 18 : 14,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  String _getShippingLabel(String method) {
    switch (method) {
      case 'INSTANT':
        return 'Instant';
      case 'NEXT_DAY':
        return 'Next Day';
      case 'REGULAR':
        return 'Regular';
      default:
        return method;
    }
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
        return 'Waiting for Courier';
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
        return Icons.info;
    }
  }

  String _formatCurrency(double amount) {
    return amount
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]}.',
        );
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year} '
        '${dt.hour.toString().padLeft(2, '0')}:'
        '${dt.minute.toString().padLeft(2, '0')}';
  }
}
