import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = controller.profileData;
        if (user.isEmpty) {
          return const Center(child: Text('Failed to load profile'));
        }

        final roles = (user['roles'] as List<dynamic>?)?.join(', ') ?? '';
        final activeRole = user['activeRole'] ?? 'None';
        final financialSummary = user['financialSummary'] ?? {};

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
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Center(
                child: Text(
                  user['email'] ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              const Text(
                'Roles Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
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
                    _buildInfoRow('Available Roles', roles),
                    const Divider(height: 24),
                    _buildInfoRow(
                      'Active Role',
                      activeRole,
                      isHighlighted: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                'Financial Summary',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
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
                    if (financialSummary['buyer'] != null) ...[
                      _buildInfoRow(
                        'Wallet Balance (Buyer)',
                        'Rp ${financialSummary['buyer']['walletBalance'] ?? 0}',
                      ),
                      const SizedBox(height: 8),
                    ],
                    if (financialSummary['seller'] != null) ...[
                      _buildInfoRow(
                        'Total Income (Seller)',
                        'Rp ${financialSummary['seller']['totalIncome'] ?? 0}',
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        'Store Name',
                        financialSummary['seller']['store']?['name'] ??
                            'Not setup',
                      ),
                    ],
                    if (financialSummary.isEmpty)
                      const Text(
                        'No financial data available',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              const Text(
                'My Account',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
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
              const SizedBox(height: 48),

              CustomButton(
                text: 'Logout',
                width: double.infinity,
                type: ButtonType.outline,
                textColor: Colors.red,
                borderColor: Colors.red,
                onPressed: controller.logout,
              ),
            ],
          ),
        ));
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
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: TextStyle(
              color: isHighlighted ? AppColors.primary : AppColors.textPrimary,
              fontSize: 14,
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
      trailing: const Icon(
        Icons.chevron_right,
        color: AppColors.grey400,
      ),
      onTap: onTap,
    );
  }
}
