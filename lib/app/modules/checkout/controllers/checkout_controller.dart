import 'package:get/get.dart';
import '../../../data/models/address_model.dart';
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
  final RxBool isFetchingSummary = false.obs;
  final RxDouble walletBalance = 0.0.obs;
  
  final RxString discountCode = ''.obs;
  final RxDouble subtotal = 0.0.obs;
  final RxDouble deliveryFee = 0.0.obs;
  final RxDouble ppnAmount = 0.0.obs;
  final RxDouble discountAmount = 0.0.obs;
  final RxDouble totalAmount = 0.0.obs;

  final Map<String, double> shippingFees = {
    'INSTANT': 50000,
    'NEXT_DAY': 30000,
    'REGULAR': 15000,
  };

  final Map<String, String> shippingLabels = {
    'INSTANT': 'Instant',
    'NEXT_DAY': 'Next Day',
    'REGULAR': 'Regular',
  };

  CartController get cartController => Get.find<CartController>();

  bool get isBalanceSufficient => walletBalance.value >= totalAmount.value;

  @override
  void onInit() {
    super.onInit();
    loadCheckoutData();
  }

  Future<void> loadCheckoutData() async {
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
      
      await fetchSummary();
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

  Future<void> fetchSummary() async {
    if (selectedAddress.value == null) return;
    
    try {
      isFetchingSummary.value = true;
      final data = {
        'addressId': selectedAddress.value!.id,
        'deliveryMethod': selectedShippingMethod.value,
        if (discountCode.value.isNotEmpty) 'discountCode': discountCode.value,
      };
      
      final summary = await _orderProvider.getCheckoutSummary(data);
      subtotal.value = double.parse(summary['subtotal'].toString());
      deliveryFee.value = double.parse(summary['deliveryFee'].toString());
      ppnAmount.value = double.parse(summary['tax'].toString());
      discountAmount.value = double.parse(summary['discount'].toString());
      totalAmount.value = double.parse(summary['total'].toString());
    } catch (e) {
      Get.snackbar(
        'Warning',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.TOP,
      );
      discountCode.value = ''; // Reset invalid code
    } finally {
      isFetchingSummary.value = false;
    }
  }

  void selectShippingMethod(String method) {
    selectedShippingMethod.value = method;
    fetchSummary();
  }

  void selectAddress(AddressModel address) {
    selectedAddress.value = address;
    fetchSummary();
  }
  
  void applyDiscountCode(String code) {
    discountCode.value = code;
    fetchSummary();
  }

  Future<void> checkout() async {
    if (selectedAddress.value == null) {
      Get.snackbar(
        'Error',
        'Please select a shipping address first',
        snackPosition: SnackPosition.TOP,
      );
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
        if (discountCode.value.isNotEmpty) 'discountCode': discountCode.value,
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
