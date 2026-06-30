import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(context),

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
                  child: _buildLoginForm(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          if (Navigator.canPop(context))
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.white,
                ),
                onPressed: () => Get.back(),
              ),
            ),

          const SizedBox(height: 16),

          Image.asset('assets/images/Logo.png', width: 80, fit: BoxFit.contain),

          const SizedBox(height: 32),

          Text(
            'Sign in to your\nAccount',
            textAlign: TextAlign.center,
            style: AppTextStyles.heading2.copyWith(color: AppColors.white),
          ),

          const SizedBox(height: 12),

          Text(
            'Enter your email and password to log in',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.white.withValues(alpha: 0.9),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextField(
            controller: controller.emailController,
            focusNode: controller.emailFocusNode,
            type: TextFieldType.email,
            hint: 'Enter your email',
            validator: controller.validateEmail,
            textInputAction: TextInputAction.next,
            onSubmitted: (value) => controller.focusPassword(),
          ),

          const SizedBox(height: 16),

          CustomTextField(
            controller: controller.passwordController,
            focusNode: controller.passwordFocusNode,
            type: TextFieldType.password,
            hint: 'Enter your password',
            validator: controller.validatePassword,
            textInputAction: TextInputAction.done,
            onSubmitted: (value) => controller.login(),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Obx(
                () => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: controller.rememberMe.value,
                      onChanged: (value) => controller.toggleRememberMe(),
                      activeColor: AppColors.primary,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    GestureDetector(
                      onTap: controller.toggleRememberMe,
                      child: Text(
                        'Remember me',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.grey600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              GestureDetector(
                onTap: controller.navigateToForgotPassword,
                child: Text(
                  'Forgot Password ?',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          Obx(
            () => CustomButton(
              text: 'Log In',
              size: ButtonSize.large,
              isLoading: controller.isLoading.value,
              onPressed: controller.login,
            ),
          ),

          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account? ",
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.grey600,
                ),
              ),
              GestureDetector(
                onTap: controller.navigateToRegister,
                child: Text(
                  'Sign Up',
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
