import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controllers/seller_dashboard_controller.dart';

class SellerSettingsTab extends GetView<SellerDashboardController> {
  const SellerSettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Settings', style: AppTextStyles.heading3),
          const SizedBox(height: 32),
          if (controller.hasMultipleRoles) ...[
            _buildSettingItem(
              icon: Icons.swap_horiz,
              title: 'Change Role',
              subtitle: 'Switch between your available roles',
              onTap: () => Get.toNamed('/role-selection'),
            ),
            const SizedBox(height: 16),
          ],
          _buildSettingItem(
              icon: Icons.logout,
              title: 'Log Out',
              subtitle: 'Sign out of your account',
              onTap: controller.logout,
              isDestructive: true,
            ),
          ],
        ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive ? AppColors.error : AppColors.textPrimary;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDestructive ? AppColors.error.withValues(alpha: 0.3) : AppColors.grey200),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDestructive ? AppColors.error.withValues(alpha: 0.1) : AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: isDestructive ? AppColors.error : AppColors.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.heading6.copyWith(color: color)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey600)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.grey400),
          ],
        ),
      ),
    );
  }
}
