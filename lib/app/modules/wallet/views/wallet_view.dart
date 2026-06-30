import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_dialog.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../controllers/wallet_controller.dart';
import 'package:intl/intl.dart';

class WalletView extends GetView<WalletController> {
  const WalletView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Wallet',
          style: AppTextStyles.heading4,
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: controller.loadWalletData,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _buildBalanceCard(),
              const SizedBox(height: 24),
              _buildQuickTopUp(),
              const SizedBox(height: 24),
              _buildTransactionHistory(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color(0xFF2D6B5F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Balance',
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 8),
          Obx(() => Text(
                _formatCurrency(controller.balance),
                style: AppTextStyles.heading1.copyWith(color: Colors.white),
              )),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              text: 'Top Up',
              icon: const Icon(Icons.add, color: AppColors.primary),
              backgroundColor: Colors.white,
              textColor: AppColors.primary,
              width: double.infinity,
              onPressed: () => _showTopUpDialog(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickTopUp() {
    final amounts = [50000, 100000, 200000, 500000];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Top Up', style: AppTextStyles.heading5),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 2.8,
          children: amounts.map((amount) {
            return CustomButton(
              type: ButtonType.outline,
              text: _formatCurrency(amount.toDouble()),
              onPressed: () {
                controller.topUpAmountController.text = amount.toString();
                _showTopUpDialog();
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTransactionHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Transaction History', style: AppTextStyles.heading5),
        const SizedBox(height: 12),
        Obx(() {
          if (controller.transactions.isEmpty) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppColors.grey50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Icon(Icons.receipt_long, size: 48, color: AppColors.grey300),
                  const SizedBox(height: 12),
                  Text(
                    'No transactions yet',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.transactions.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final tx = controller.transactions[index];
              final isCredit =
                  tx.type == 'TOP_UP' || tx.type == 'REFUND';
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isCredit
                        ? AppColors.successLight
                        : AppColors.errorLight,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                    color: isCredit ? AppColors.success : AppColors.error,
                    size: 20,
                  ),
                ),
                title: Text(
                  (tx.description.isNotEmpty ? tx.description : tx.type)
                      .replaceAll(RegExp(r'(?i)dummy\s*'), '')
                      .trim(),
                  style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                ),
                subtitle: tx.createdAt != null
                    ? Text(
                        _formatDate(tx.createdAt!),
                        style: AppTextStyles.caption,
                      )
                    : null,
                trailing: Text(
                  isCredit 
                      ? '+${_formatCurrency(tx.amount.abs())}' 
                      : _formatCurrency(-tx.amount.abs()),
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isCredit ? AppColors.success : AppColors.error,
                  ),
                ),
              );
            },
          );
        }),
      ],
    );
  }

  void _showTopUpDialog() {
    Get.dialog(
      CustomDialog(
        title: 'Top Up Wallet',
        textConfirm: 'Top Up',
        textCancel: 'Cancel',
        showCancelButton: true,
        onCancel: () {
          controller.topUpAmountController.clear();
        },
        onConfirm: () {
          if (!controller.isTopUpLoading.value) {
            controller.topUp();
          }
        },
        content: CustomTextField(
          controller: controller.topUpAmountController,
          type: TextFieldType.number,
          hint: 'Enter amount',
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 16, right: 8, top: 14, bottom: 14),
            child: Text('Rp ', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary)),
          ),
        ),
      ),
    );
  }

  String _formatCurrency(double amount) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(amount);
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
