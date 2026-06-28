import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),

            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: _buildRegisterForm(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 24),
          
          Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: controller.navigateToLogin,
                  icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.shield, size: 30, color: AppColors.primary),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Text(
            'Create an\nAccount',
            textAlign: TextAlign.center,
            style: AppTextStyles.heading2.copyWith(
              color: AppColors.white,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            'Enter your details to register',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.white.withValues(alpha: 0.9),
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildRegisterForm() {
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextField(
            controller: controller.nameController,
            focusNode: controller.nameFocusNode,
            type: TextFieldType.text,
            hint: 'Enter your name',
            validator: controller.validateName,
            textInputAction: TextInputAction.next,
            onSubmitted: (value) => controller.emailFocusNode.requestFocus(),
          ),

          const SizedBox(height: 16),

          CustomTextField(
            controller: controller.emailController,
            focusNode: controller.emailFocusNode,
            type: TextFieldType.email,
            hint: 'Enter your email',
            validator: controller.validateEmail,
            textInputAction: TextInputAction.next,
            onSubmitted: (value) => controller.passwordFocusNode.requestFocus(),
          ),

          const SizedBox(height: 16),

          CustomTextField(
            controller: controller.passwordController,
            focusNode: controller.passwordFocusNode,
            type: TextFieldType.password,
            hint: 'Enter your password',
            validator: controller.validatePassword,
            textInputAction: TextInputAction.next,
            onSubmitted: (value) => controller.confirmPasswordFocusNode.requestFocus(),
          ),
          
          const SizedBox(height: 16),

          CustomTextField(
            controller: controller.confirmPasswordController,
            focusNode: controller.confirmPasswordFocusNode,
            type: TextFieldType.password,
            hint: 'Confirm your password',
            validator: controller.validateConfirmPassword,
            textInputAction: TextInputAction.done,
            onSubmitted: (value) => controller.register(),
          ),

          const SizedBox(height: 24),

          Text(
            'Select Your Roles',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.grey800,
            ),
          ),
          const SizedBox(height: 8),
          Obx(
            () => Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: controller.availableRoles.map((role) {
                final isSelected = controller.selectedRoles.contains(role);
                return FilterChip(
                  label: Text(
                    role,
                    style: TextStyle(
                      color: isSelected ? AppColors.primary : AppColors.grey600,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (_) => controller.toggleRole(role),
                  selectedColor: AppColors.primary.withValues(alpha: 0.1),
                  checkmarkColor: AppColors.primary,
                  backgroundColor: AppColors.grey100,
                  side: BorderSide(
                    color: isSelected ? AppColors.primary : AppColors.grey300,
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 32),

          Obx(
            () => CustomButton(
              text: 'Register',
              size: ButtonSize.large,
              isLoading: controller.isLoading.value,
              onPressed: controller.register,
            ),
          ),

          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Already have an account? ",
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.grey600,
                ),
              ),
              GestureDetector(
                onTap: controller.navigateToLogin,
                child: Text(
                  'Log In',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
