import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../driver_dashboard/controllers/driver_dashboard_controller.dart';
import '../controllers/driver_job_detail_controller.dart';

class DriverJobDetailView extends GetView<DriverJobDetailController> {
  const DriverJobDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Job Details',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final job = controller.job.value;
        if (job == null) {
          return const Center(child: Text('Job not found'));
        }

        final store = job['store'] ?? {};
        final address = job['address'] ?? {};
        final items = job['items'] ?? [];
        
        final currencyFormatter = NumberFormat.currency(
          locale: 'id_ID',
          symbol: 'Rp ',
          decimalDigits: 0,
        );

        final earningEstimate = (job['deliveryFee'] ?? 0) * 0.8;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Estimated Earning',
                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey700),
                        ),
                        Text(
                          currencyFormatter.format(earningEstimate),
                          style: AppTextStyles.heading2.copyWith(color: AppColors.primary),
                        ),
                      ],
                    ),
                    const Icon(Icons.monetization_on, size: 48, color: AppColors.primary),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text('Delivery Route', style: AppTextStyles.heading5),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.grey200),
                ),
                child: Column(
                  children: [
                    _buildLocationItem(
                      icon: Icons.store,
                      title: 'Pickup (Store)',
                      subtitle: store['name'] ?? 'Unknown Store',
                      color: AppColors.primary,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 11),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          height: 30,
                          width: 2,
                          color: AppColors.grey300,
                        ),
                      ),
                    ),
                    _buildLocationItem(
                      icon: Icons.place,
                      title: 'Dropoff (Buyer)',
                      subtitle: address['recipientName'] ?? 'Unknown Name',
                      phone: address['phoneNumber'] ?? '-',
                      details: address['fullAddress'] ?? 'Unknown Address',
                      color: AppColors.error,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text('Order Items', style: AppTextStyles.heading5),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.grey200),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final product = item['product'] ?? {};
                    return Row(
                      children: [
                        if (product['imageUrl'] != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              product['imageUrl'],
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          )
                        else
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppColors.grey200,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.image, color: AppColors.grey400),
                          ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['name'] ?? 'Unknown Product',
                                style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${item['quantity']}x',
                                style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),
              Builder(builder: (context) {
                final dashboardController = Get.isRegistered<DriverDashboardController>()
                    ? Get.find<DriverDashboardController>()
                    : null;
                final hasActiveJob = dashboardController?.activeJob.value != null;

                return CustomButton(
                  text: hasActiveJob ? 'You have an active job' : 'Take Job',
                  onPressed: hasActiveJob ? null : () => controller.takeJob(),
                );
              }),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildLocationItem({
    required IconData icon,
    required String title,
    required String subtitle,
    String? phone,
    String? details,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey600),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
              ),
              if (phone != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.phone, size: 14, color: AppColors.grey600),
                    const SizedBox(width: 4),
                    Text(
                      phone,
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey600),
                    ),
                  ],
                ),
              ],
              if (details != null) ...[
                const SizedBox(height: 4),
                Text(
                  details,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey700),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
