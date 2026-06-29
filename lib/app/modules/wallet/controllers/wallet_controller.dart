import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/wallet_model.dart';
import '../../../data/providers/wallet_provider.dart';

class WalletController extends GetxController {
  final WalletProvider _provider = WalletProvider();

  final Rx<WalletModel?> wallet = Rx<WalletModel?>(null);
  final RxList<WalletTransactionModel> transactions =
      <WalletTransactionModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isTopUpLoading = false.obs;

  final topUpAmountController = TextEditingController();

  double get balance => wallet.value?.balance ?? 0;

  @override
  void onInit() {
    super.onInit();
    loadWalletData();
  }

  @override
  void onClose() {
    topUpAmountController.dispose();
    super.onClose();
  }

  Future<void> loadWalletData() async {
    try {
      isLoading.value = true;
      final results = await Future.wait([
        _provider.getWallet(),
        _provider.getTransactions(),
      ]);
      wallet.value = results[0] as WalletModel;
      transactions.assignAll(results[1] as List<WalletTransactionModel>);
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> topUp() async {
    final amountText = topUpAmountController.text.trim();
    if (amountText.isEmpty) return;

    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      Get.snackbar('Error', 'Masukkan jumlah yang valid',
          snackPosition: SnackPosition.TOP);
      return;
    }

    try {
      isTopUpLoading.value = true;
      final updatedWallet = await _provider.topUp(amount);
      wallet.value = updatedWallet;
      topUpAmountController.clear();
      Get.back();
      await _provider.getTransactions().then(
        (data) => transactions.assignAll(data),
      );
      Get.snackbar(
        'Success',
        'Top up Rp ${_formatCurrency(amount)} successful',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.shade50,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isTopUpLoading.value = false;
    }
  }

  String _formatCurrency(double amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    );
  }
}
