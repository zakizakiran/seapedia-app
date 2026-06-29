import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../data/models/address_model.dart';
import '../controllers/checkout_controller.dart';

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Checkout',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAddressSection(),
                    const SizedBox(height: 20),
                    _buildShippingMethodSection(),
                    const SizedBox(height: 20),
                    _buildOrderSummary(),
                    const SizedBox(height: 20),
                    _buildPaymentInfo(),
                  ],
                ),
              ),
            ),
            _buildBottomBar(),
          ],
        );
      }),
    );
  }

  Widget _buildAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Shipping Address', style: AppTextStyles.heading5),
            TextButton(
              onPressed: () => Get.toNamed('/address-list'),
              child: const Text('Change'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Obx(() {
          final address = controller.selectedAddress.value;
          if (address == null) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.error, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber, color: AppColors.error),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'No address yet',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: () => Get.toNamed('/address-form'),
                          child: const Text(
                            'Add address',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return _buildAddressCard(address);
        }),
      ],
    );
  }

  Widget _buildAddressCard(AddressModel address) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                address.label,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(address.recipientName,
              style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 2),
          Text(address.phone,
              style: const TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 2),
          Text(
            '${address.fullAddress}, ${address.city} ${address.postalCode}',
            style: const TextStyle(color: AppColors.textSecondary, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildShippingMethodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Shipping Method', style: AppTextStyles.heading5),
        const SizedBox(height: 12),
        ...controller.shippingFees.entries.map((entry) {
          return Obx(() {
            final isSelected =
                controller.selectedShippingMethod.value == entry.key;
            return GestureDetector(
              onTap: () => controller.selectShippingMethod(entry.key),
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.grey200,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isSelected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color:
                          isSelected ? AppColors.primary : AppColors.grey400,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.shippingLabels[entry.key] ?? entry.key,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            _getShippingEstimate(entry.key),
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Rp ${_formatCurrency(entry.value)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        }),
      ],
    );
  }

  Widget _buildOrderSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Order Summary', style: AppTextStyles.heading5),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.grey200),
          ),
          child: Obx(() => Column(
                children: [
                  _buildSummaryRow(
                    'Subtotal (${controller.cartController.totalItems} item)',
                    'Rp ${_formatCurrency(controller.subtotal)}',
                  ),
                  const Divider(height: 24),
                  _buildSummaryRow(
                    'Shipping Fee (${controller.shippingLabels[controller.selectedShippingMethod.value]})',
                    'Rp ${_formatCurrency(controller.deliveryFee)}',
                  ),
                  const Divider(height: 24),
                  _buildSummaryRow(
                    'PPN (12%)',
                    'Rp ${_formatCurrency(controller.ppnAmount)}',
                  ),
                  const Divider(height: 24),
                  _buildSummaryRow(
                    'Total',
                    'Rp ${_formatCurrency(controller.totalAmount)}',
                    isBold: true,
                  ),
                ],
              )),
        ),
      ],
    );
  }

  Widget _buildPaymentInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Obx(() {
        final sufficient = controller.isBalanceSufficient;
        return Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: sufficient ? AppColors.successLight : AppColors.errorLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.account_balance_wallet,
                color: sufficient ? AppColors.success : AppColors.error,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Wallet Balance',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                  Text(
                    'Rp ${_formatCurrency(controller.walletBalance.value)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: sufficient ? AppColors.textPrimary : AppColors.error,
                    ),
                  ),
                ],
              ),
            ),
            if (!sufficient)
              TextButton(
                onPressed: () => Get.toNamed('/wallet'),
                child: const Text('Top Up'),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, -4),
            blurRadius: 10,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Obx(() => CustomButton(
              text: 'Pay Rp ${_formatCurrency(controller.totalAmount)}',
              width: double.infinity,
              size: ButtonSize.large,
              isLoading: controller.isCheckingOut.value,
              onPressed: controller.isBalanceSufficient
                  ? controller.checkout
                  : null,
            )),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isBold ? AppColors.textPrimary : AppColors.textSecondary,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            fontSize: isBold ? 18 : 14,
          ),
        ),
      ],
    );
  }

  String _getShippingEstimate(String method) {
    switch (method) {
      case 'INSTANT':
        return '2-4 hours estimated';
      case 'NEXT_DAY':
        return '1 working day estimated';
      case 'REGULAR':
        return '3-5 working days estimated';
      default:
        return '';
    }
  }

  String _formatCurrency(double amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    );
  }
}
