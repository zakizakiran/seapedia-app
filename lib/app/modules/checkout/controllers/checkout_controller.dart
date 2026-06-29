import 'package:get/get.dart';
import '../../../data/models/address_model.dart';
import '../../../data/models/order_model.dart';
import '../../../data/providers/address_provider.dart';
import '../../../data/providers/order_provider.dart';
import '../../../data/providers/wallet_provider.dart';
import '../../cart/controllers/cart_controller.dart';

class CheckoutController extends GetxController {
  final OrderProvider _orderProvider = OrderProvider();
  final AddressProvider _addressProvider = AddressProvider();
  final WalletProvider _walletProvider = WalletProvider();

  final RxList<AddressModel> addresses = <AddressModel>[].obs;
  final Rx<AddressModel?> selectedAddress = Rx<AddressModel?>(null);
  final RxString selectedShippingMethod = 'REGULAR'.obs;
  final RxBool isLoading = true.obs;
  final RxBool isCheckingOut = false.obs;
  final RxDouble walletBalance = 0.0.obs;

  final Map<String, double> shippingFees = {
    'INSTANT': 25000,
    'NEXT_DAY': 15000,
    'REGULAR': 10000,
  };

  final Map<String, String> shippingLabels = {
    'INSTANT': 'Instant',
    'NEXT_DAY': 'Next Day',
    'REGULAR': 'Regular',
  };

  CartController get cartController => Get.find<CartController>();

  double get subtotal => cartController.subtotal;

  double get deliveryFee => shippingFees[selectedShippingMethod.value] ?? 10000;

  double get ppnAmount => (subtotal) * 0.12;

  double get totalAmount => subtotal + deliveryFee + ppnAmount;

  bool get isBalanceSufficient => walletBalance.value >= totalAmount;

  @override
  void onInit() {
    super.onInit();
    _loadCheckoutData();
  }

  Future<void> _loadCheckoutData() async {
    try {
      isLoading.value = true;
      final results = await Future.wait([
        _addressProvider.getAddresses(),
        _walletProvider.getWallet(),
      ]);

      addresses.assignAll(results[0] as List<AddressModel>);
      walletBalance.value = (results[1] as dynamic).balance;

      final defaultAddr = addresses.firstWhereOrNull((a) => a.isDefault);
      selectedAddress.value = defaultAddr ?? addresses.firstOrNull;
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

  void selectShippingMethod(String method) {
    selectedShippingMethod.value = method;
  }

  void selectAddress(AddressModel address) {
    selectedAddress.value = address;
  }

  Future<void> checkout() async {
    if (selectedAddress.value == null) {
      Get.snackbar('Error', 'Please select a shipping address first',
          snackPosition: SnackPosition.TOP);
      return;
    }

    if (!isBalanceSufficient) {
      Get.snackbar(
        'Insufficient Balance',
        'Your wallet balance is insufficient. Please top up first.',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    try {
      isCheckingOut.value = true;
      final data = {
        'addressId': selectedAddress.value!.id,
        'deliveryMethod': selectedShippingMethod.value,
      };

      final order = await _orderProvider.checkout(data);
      await cartController.fetchCart();

      Get.offNamed('/order-detail', arguments: order.id);
      Get.snackbar(
        'Order Successful',
        'Your order is being processed',
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        'Checkout Failed',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isCheckingOut.value = false;
    }
  }
}
