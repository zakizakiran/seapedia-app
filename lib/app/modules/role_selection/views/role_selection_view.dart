import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../controllers/role_selection_controller.dart';

class RoleSelectionView extends GetView<RoleSelectionController> {
  const RoleSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'assets/images/Logo.png',
                width: 80,
                height: 80,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 32),
              Text(
                'Select Your Role',
                textAlign: TextAlign.center,
                style: AppTextStyles.heading2.copyWith(color: AppColors.white),
              ),
              const SizedBox(height: 8),
              Text(
                'Your account has more than one role.\nPlease select the role you want to use currently.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.white.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 48),
              
              Obx(() {
                if (controller.availableRoles.isEmpty) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.white));
                }
                
                return Column(
                  children: controller.availableRoles.map((role) {
                    final isSelected = controller.selectedRole.value == role;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: InkWell(
                        onTap: () => controller.selectRole(role),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.white : AppColors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? AppColors.white : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _getIconForRole(role),
                                color: isSelected ? AppColors.primary : AppColors.white,
                                size: 24,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  role,
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isSelected ? AppColors.primary : AppColors.white,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                const Icon(
                                  Icons.check_circle,
                                  color: AppColors.primary,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              }),
              
              const SizedBox(height: 32),
              
              Obx(() => CustomButton(
                text: 'Continue',
                onPressed: controller.selectedRole.value != null ? controller.confirmRole : () {},
                isLoading: controller.isLoading.value,
                backgroundColor: controller.selectedRole.value != null ? AppColors.white : AppColors.white.withValues(alpha: 0.5),
                textColor: AppColors.primary,
              )),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForRole(String role) {
    switch (role.toUpperCase()) {
      case 'BUYER':
        return Icons.shopping_bag;
      case 'SELLER':
        return Icons.storefront;
      case 'DRIVER':
        return Icons.motorcycle;
      case 'ADMIN':
        return Icons.admin_panel_settings;
      default:
        return Icons.person;
    }
  }
}
