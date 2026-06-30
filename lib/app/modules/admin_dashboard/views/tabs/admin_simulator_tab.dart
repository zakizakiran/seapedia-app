import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../controllers/admin_dashboard_controller.dart';

class AdminSimulatorTab extends GetView<AdminDashboardController> {
  const AdminSimulatorTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      
      return SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTimeSimulatorCard(),
            const SizedBox(height: 16),
            _buildSimulationInfoCard(),
            const SizedBox(height: 32),
            _buildOverdueOrdersSection(),
          ],
        ),
      );
    });
  }

  Widget _buildSimulationInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.lightbulb_outline, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Panduan Pengujian Overdue',
                  style: AppTextStyles.heading5.copyWith(color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoStep('1', 'Tekan tombol "+1 Day" untuk memajukan waktu sistem (simulasi pergantian hari).'),
          const SizedBox(height: 12),
          _buildInfoStep('2', 'Pesanan yang melewati batas SLA (Instant 1 hari, Next Day 2 hari, Regular 7 hari) akan otomatis masuk ke daftar "Overdue".'),
          const SizedBox(height: 12),
          _buildInfoStep('3', 'Tekan tombol "Process Overdue" di bawah untuk memicu eksekusi Auto Refund dana ke pembeli & Auto Return stok barang ke penjual.'),
        ],
      ),
    );
  }

  Widget _buildInfoStep(String number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          margin: const EdgeInsets.only(top: 2),
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.4),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSimulatorCard() {
    final timeInfo = controller.timeInfo.value;
    if (timeInfo == null) return const SizedBox.shrink();

    final offsetDays = timeInfo['offsetDays'] ?? 0;
    final isSimulated = offsetDays > 0;
    final currentTimeStr = timeInfo['simulatedTime'] ?? '';
    final parsedTime = DateTime.tryParse(currentTimeStr) ?? DateTime.now();
    final formattedTime = DateFormat('dd MMM yyyy, HH:mm').format(parsedTime.toLocal());

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isSimulated ? AppColors.warning.withValues(alpha: 0.1) : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSimulated ? AppColors.warning : AppColors.grey200,
          width: isSimulated ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.schedule, 
                color: isSimulated ? AppColors.warning : AppColors.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'System Time',
                  style: AppTextStyles.heading5,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isSimulated) ...[
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.warning,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'SIMULATED',
                    style: TextStyle(color: AppColors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          Text(
            formattedTime,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          if (isSimulated) ...[
            const SizedBox(height: 4),
            Text(
              'Offset: +$offsetDays days from actual time',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ],
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: '+1 Day',
                  onPressed: controller.simulateNextDay,
                ),
              ),
              if (isSimulated) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    text: 'Reset',
                    type: ButtonType.outline,
                    onPressed: controller.resetSimulatedTime,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverdueOrdersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overdue Orders',
          style: AppTextStyles.heading5,
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton.icon(
            onPressed: controller.processOverdue,
            icon: const Icon(Icons.autorenew, size: 24),
            label: const Text(
              'Process Overdue', 
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (controller.overdueOrders.isEmpty)
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
                'No overdue orders found',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.overdueOrders.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final order = controller.overdueOrders[index];
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
                          color: AppColors.error.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.warning_amber_rounded, color: AppColors.error),
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
                                    'Order #${order['id']?.substring(0, 8).toUpperCase()}',
                                    style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.error.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    order['status'] ?? 'UNKNOWN',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.error,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Method: ${order['deliveryMethod']}',
                              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.access_time_filled,
                                  size: 14,
                                  color: AppColors.error,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    'Created: ${DateFormat('dd MMM yyyy, HH:mm').format(DateTime.parse(order['createdAt']).toLocal())}',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.error,
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
