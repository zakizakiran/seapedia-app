import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
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
          style: AppTextStyles.heading4,
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
                    _buildProductSection(),
                    const SizedBox(height: 20),
                    _buildShippingMethodSection(),
                    const SizedBox(height: 20),
                    _buildDiscountSection(),
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
              onPressed: () async {
                final selected = await Get.toNamed('/address-list');
                if (selected != null && selected is AddressModel) {
                  controller.selectedAddress.value = selected;
                  controller.fetchSummary();
                } else {
                  controller.loadCheckoutData();
                }
              },
              child: const Text(
                'Change',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
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
                border: Border.all(
                  color: AppColors.error,
                  style: BorderStyle.solid,
                ),
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
                        Text(
                          'No address yet',
                          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: () async {
                            await Get.toNamed('/address-form');
                            controller.loadCheckoutData();
                          },
                          child: Text(
                            'Add address',
                            style: AppTextStyles.bodyMedium.copyWith(
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
                style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            address.recipientName,
            style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 2),
          Text(
            address.phone,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 2),
          Text(
            '${address.fullAddress}, ${address.city} ${address.postalCode}',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildProductSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Products', style: AppTextStyles.heading5),
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
              Row(
                children: [
                  const Icon(
                    Icons.storefront,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Obx(
                    () => Text(
                      controller.cartController.currentStoreName.value,
                      style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              Obx(
                () => ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.cartController.cartItems.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final item = controller.cartController.cartItems[index];
                    final product = item.product;
                    return Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            width: 56,
                            height: 56,
                            color: AppColors.grey100,
                            child: product.imageUrl.isNotEmpty
                                ? Image.network(
                                    product.imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, _, _) => const Icon(
                                      Icons.image,
                                      color: AppColors.grey300,
                                    ),
                                  )
                                : const Icon(
                                    Icons.image,
                                    color: AppColors.grey300,
                                  ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.title,
                                style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (item.selectedVariation != null) ...[
                                const SizedBox(height: 2),
                                Text(
                                  'Variation: ${item.selectedVariation}',
                                  style: AppTextStyles.caption,
                                ),
                              ],
                              Text(
                                '${item.quantity}x ${_formatCurrency(product.price)}',
                                style: AppTextStyles.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
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
                      color: isSelected ? AppColors.primary : AppColors.grey400,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.shippingLabels[entry.key] ?? entry.key,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isSelected ? AppColors.primary : AppColors.textPrimary,
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
                      _formatCurrency(entry.value),
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isSelected ? AppColors.primary : AppColors.textPrimary,
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

  Widget _buildDiscountSection() {
    final TextEditingController discountController = TextEditingController(
      text: controller.discountCode.value,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Discount / Promo Code', style: AppTextStyles.heading5),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: discountController,
                hint: 'Enter code here',
              ),
            ),
            const SizedBox(width: 12),
            CustomButton(
              text: 'Apply',
              onPressed: () =>
                  controller.applyDiscountCode(discountController.text),
            ),
          ],
        ),
        Obx(() {
          if (controller.discountCode.value.isNotEmpty &&
              controller.discountAmount.value > 0) {
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Discount code "${controller.discountCode.value}" applied!',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }
          return const SizedBox.shrink();
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
          child: Obx(() {
            if (controller.isFetchingSummary.value) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return Column(
              children: [
                _buildSummaryRow(
                  'Subtotal (${controller.cartController.totalItems} item)',
                  _formatCurrency(controller.subtotal.value),
                ),
                const Divider(height: 24),
                _buildSummaryRow(
                  'Shipping Fee (${controller.shippingLabels[controller.selectedShippingMethod.value]})',
                  _formatCurrency(controller.deliveryFee.value),
                ),
                if (controller.discountAmount.value > 0) ...[
                  const Divider(height: 24),
                  _buildSummaryRow(
                    'Discount',
                    _formatCurrency(-controller.discountAmount.value),
                    textColor: AppColors.success,
                  ),
                ],
                const Divider(height: 24),
                _buildSummaryRow(
                  'PPN (12%)',
                  _formatCurrency(controller.ppnAmount.value),
                ),
                const Divider(height: 24),
                _buildSummaryRow(
                  'Total',
                  _formatCurrency(controller.totalAmount.value),
                  isBold: true,
                ),
              ],
            );
          }),
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
                color: sufficient
                    ? AppColors.successLight
                    : AppColors.errorLight,
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
                    style: AppTextStyles.bodySmall,
                  ),
                  Text(
                    _formatCurrency(controller.walletBalance.value),
                    style: AppTextStyles.heading6.copyWith(
                      color: sufficient ? AppColors.textPrimary : AppColors.error,
                    ),
                  ),
                ],
              ),
            ),
            if (!sufficient)
              TextButton(
                onPressed: () async {
                  await Get.toNamed('/wallet');
                  controller.loadCheckoutData();
                },
                child: const Text(
                  'Top Up',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
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
        child: Obx(
          () => CustomButton(
            text: 'Pay ${_formatCurrency(controller.totalAmount.value)}',
            width: double.infinity,
            size: ButtonSize.large,
            isLoading: controller.isCheckingOut.value,
            onPressed: controller.isBalanceSufficient
                ? controller.checkout
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isBold = false,
    Color? textColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isBold ? AppColors.textPrimary : AppColors.textSecondary,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: (isBold ? AppTextStyles.heading5 : AppTextStyles.bodyMedium).copyWith(
            color: textColor ?? AppColors.textPrimary,
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
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(amount);
  }
}
