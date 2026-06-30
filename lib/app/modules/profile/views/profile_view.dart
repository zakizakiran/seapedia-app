import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controllers/profile_controller.dart';
import 'package:intl/intl.dart';
import '../../../core/utils/string_extensions.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('Profile', style: AppTextStyles.heading3)),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = controller.profileData;
        if (user.isEmpty) {
          return const Center(child: Text('Failed to load profile'));
        }

        final activeRole = user['activeRole'] ?? 'None';
        final financialSummary = user['financialSummary'] ?? {};

        final currencyFormatter = NumberFormat.currency(
          locale: 'id_ID',
          symbol: 'Rp ',
          decimalDigits: 0,
        );

        return RefreshIndicator(
          onRefresh: controller.fetchProfile,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    user['name'] ?? '',
                    style: AppTextStyles.heading4.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    user['email'] ?? '',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                Text('Active Role', style: AppTextStyles.heading5),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.grey200),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.badge, color: AppColors.primary, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Current Session', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                          const SizedBox(height: 4),
                          Text(activeRole, style: AppTextStyles.heading6.copyWith(color: AppColors.primary)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                Text('Financial Summary', style: AppTextStyles.heading5),
                const SizedBox(height: 12),
                if (financialSummary['buyer'] != null)
                  _buildFinancialCard(
                    title: 'Buyer Summary',
                    icon: Icons.shopping_cart,
                    color: AppColors.primary,
                    children: [
                      _buildInfoRow(
                        'Wallet Balance',
                        currencyFormatter.format(
                          financialSummary['buyer']['walletBalance'] ?? 0,
                        ),
                        isHighlighted: true,
                      ),
                      const Divider(height: 24),
                      _buildInfoRow(
                        'Total Spending',
                        currencyFormatter.format(
                          financialSummary['buyer']['totalSpending'] ?? 0,
                        ),
                      ),
                    ],
                  ),
                if (financialSummary['seller'] != null)
                  _buildFinancialCard(
                    title: 'Seller Summary',
                    icon: Icons.storefront,
                    color: AppColors.secondary,
                    children: [
                      _buildInfoRow(
                        'Total Income',
                        currencyFormatter.format(
                          financialSummary['seller']['totalIncome'] ?? 0,
                        ),
                        isHighlighted: true,
                      ),
                      const Divider(height: 24),
                      _buildInfoRow(
                        'Store Name',
                        (financialSummary['seller']['store']?['name'] as String?)?.unescapeHtml ??
                            'Not setup',
                      ),
                    ],
                  ),
                if (financialSummary['driver'] != null)
                  _buildFinancialCard(
                    title: 'Driver Summary',
                    icon: Icons.local_shipping,
                    color: AppColors.alternative,
                    children: [
                      _buildInfoRow(
                        'Total Earnings',
                        currencyFormatter.format(
                          financialSummary['driver']['totalEarnings'] ?? 0,
                        ),
                        isHighlighted: true,
                      ),
                    ],
                  ),
                if (financialSummary.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.grey200),
                    ),
                    child: Text(
                      'No financial data available',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                const SizedBox(height: 32),

                Text('My Account', style: AppTextStyles.heading5),
                const SizedBox(height: 12),
                Material(
                  color: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: AppColors.grey200),
                  ),
                  child: Column(
                    children: [
                      _buildMenuTile(
                        icon: Icons.account_balance_wallet,
                        title: 'Wallet',
                        onTap: () async {
                          await Get.toNamed('/wallet');
                          controller.fetchProfile();
                        },
                      ),
                      const Divider(height: 1),
                      _buildMenuTile(
                        icon: Icons.receipt_long,
                        title: 'My Orders',
                        onTap: () async {
                          await Get.toNamed('/order-list');
                          controller.fetchProfile();
                        },
                      ),
                      const Divider(height: 1),
                      _buildMenuTile(
                        icon: Icons.location_on,
                        title: 'Shipping Address',
                        onTap: () async {
                          await Get.toNamed('/address-list');
                          controller.fetchProfile();
                        },
                      ),
                    ],
                  ),
                ),
                if ((user['roles'] as List<dynamic>?) != null &&
                    (user['roles'] as List<dynamic>).length > 1) ...[
                  const SizedBox(height: 12),
                  _buildSettingItem(
                    icon: Icons.swap_horiz,
                    title: 'Change Role',
                    subtitle: 'Switch between your available roles',
                    onTap: () => Get.toNamed('/role-selection'),
                  ),
                ],
                if ((user['roles'] as List<dynamic>?) != null &&
                    !(user['roles'] as List<dynamic>).contains('BUYER')) ...[
                  const SizedBox(height: 12),
                  _buildSettingItem(
                    icon: Icons.shopping_cart,
                    title: 'Become a Buyer',
                    subtitle: 'Start buying products on Seapedia',
                    onTap: () => controller.addRole('BUYER'),
                  ),
                ],
                if ((user['roles'] as List<dynamic>?) != null &&
                    !(user['roles'] as List<dynamic>).contains('SELLER')) ...[
                  const SizedBox(height: 12),
                  _buildSettingItem(
                    icon: Icons.storefront,
                    title: 'Become a Seller',
                    subtitle: 'Start selling products on Seapedia',
                    onTap: () => controller.addRole('SELLER'),
                  ),
                ],
                if ((user['roles'] as List<dynamic>?) != null &&
                    !(user['roles'] as List<dynamic>).contains('DRIVER')) ...[
                  const SizedBox(height: 12),
                  _buildSettingItem(
                    icon: Icons.local_shipping,
                    title: 'Become a Driver',
                    subtitle: 'Start delivering orders',
                    onTap: () => controller.addRole('DRIVER'),
                  ),
                ],
                const SizedBox(height: 12),

                _buildSettingItem(
                  icon: Icons.logout,
                  title: 'Log Out',
                  subtitle: 'Sign out of your account',
                  onTap: controller.logout,
                  isDestructive: true,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value, {
    bool isHighlighted = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              color: isHighlighted ? AppColors.primary : AppColors.textPrimary,
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            )
          : null,
      trailing: const Icon(Icons.chevron_right, color: AppColors.grey400),
      onTap: onTap,
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
          border: Border.all(
            color: isDestructive
                ? AppColors.error.withValues(alpha: 0.3)
                : AppColors.grey200,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDestructive
                    ? AppColors.error.withValues(alpha: 0.1)
                    : AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isDestructive ? AppColors.error : AppColors.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.heading6.copyWith(color: color),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.grey600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.grey400),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialCard({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
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
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Text(title, style: AppTextStyles.heading6),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}
