import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../controllers/admin_dashboard_controller.dart';

class AdminMonitoringTab extends GetView<AdminDashboardController> {
  const AdminMonitoringTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      
      return RefreshIndicator(
        onRefresh: controller.fetchDashboardStats,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('System Overview', style: AppTextStyles.heading4),
              const SizedBox(height: 16),
              _buildStatsGrid(),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 0.85,
      children: [
        _buildStatCard(
          title: 'Total Users',
          value: controller.usersCount.value.toString(),
          icon: Icons.people,
          color: Colors.blue,
          onTap: () => Get.toNamed('/admin-users'),
        ),
        _buildStatCard(
          title: 'Reg. Stores',
          value: controller.storesCount.value.toString(),
          icon: Icons.store,
          color: Colors.orange,
          onTap: () => Get.toNamed('/admin-stores'),
        ),
        _buildStatCard(
          title: 'Total Products',
          value: controller.productsCount.value.toString(),
          icon: Icons.inventory_2,
          color: Colors.green,
          onTap: () => Get.toNamed('/admin-products'),
        ),
        _buildStatCard(
          title: 'Total Orders',
          value: controller.ordersCount.value.toString(),
          icon: Icons.shopping_cart,
          color: Colors.purple,
          onTap: () => Get.toNamed('/admin-orders'),
        ),
        _buildStatCard(
          title: 'Active Jobs',
          value: controller.jobsCount.value.toString(),
          icon: Icons.local_shipping,
          color: Colors.teal,
          onTap: () => Get.toNamed('/admin-jobs'),
        ),
        _buildStatCard(
          title: 'Overdue',
          value: controller.overdueOrdersCount.value.toString(),
          icon: Icons.warning_amber,
          color: AppColors.error,
          onTap: () => controller.changeTab(2), // Redirects to Simulator Tab
        ),
        _buildStatCard(
          title: 'Vouchers',
          value: controller.vouchersCount.value.toString(),
          icon: Icons.card_giftcard,
          color: Colors.indigo,
          onTap: () => controller.changeTab(1), // Redirects to Discounts Tab
        ),
        _buildStatCard(
          title: 'Promos',
          value: controller.promosCount.value.toString(),
          icon: Icons.local_offer,
          color: Colors.pink,
          onTap: () => controller.changeTab(1),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.grey200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const Spacer(),
              Text(title, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey600)),
              const SizedBox(height: 4),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  value,
                  style: AppTextStyles.heading4.copyWith(color: color),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
