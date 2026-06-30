import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/custom_button.dart';
import '../controllers/admin_dashboard_controller.dart';

class AdminCreateDiscountView extends GetView<AdminDashboardController> {
  const AdminCreateDiscountView({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine if it's a voucher or promo based on arguments passed via Get.toNamed
    final bool isVoucher = Get.arguments?['isVoucher'] ?? true;
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(isVoucher ? 'Create Voucher' : 'Create Promo', style: AppTextStyles.heading4),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.grey200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      label: 'Code',
                      controller: isVoucher ? controller.voucherCodeController : controller.promoCodeController,
                      hint: 'e.g. SUMMER24',
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Discount Amount (Rp) - Optional',
                      controller: isVoucher ? controller.voucherAmountController : controller.promoAmountController,
                      keyboardType: TextInputType.number,
                      hint: 'e.g. 50000',
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Discount Percent (%) - Optional',
                      controller: isVoucher ? controller.voucherPercentController : controller.promoPercentController,
                      keyboardType: TextInputType.number,
                      hint: 'e.g. 15',
                    ),
                    if (isVoucher) ...[
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'Remaining Usage',
                        controller: controller.voucherUsageController,
                        keyboardType: TextInputType.number,
                        hint: 'e.g. 100',
                      ),
                    ],
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Expiry Date',
                      controller: isVoucher ? controller.voucherExpiryDateController : controller.promoExpiryDateController,
                      hint: 'Select expiry date (e.g. 2026-12-31)',
                      readOnly: true,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today, color: AppColors.primary, size: 20),
                        onPressed: () => controller.selectExpiryDate(isVoucher),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Obx(
                      () => CustomButton(
                        width: double.infinity,
                        text: isVoucher ? 'Create Voucher' : 'Create Promo',
                        backgroundColor: isVoucher ? AppColors.primary : Colors.pink,
                        isLoading: controller.isLoading.value,
                        onPressed: () {
                          if (isVoucher) {
                            controller.createVoucher();
                          } else {
                            controller.createPromo();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
