import 'package:get/get.dart';
import '../../../data/models/order_model.dart';
import '../../../data/providers/order_provider.dart';

class SellerOrdersController extends GetxController {
  final OrderProvider _provider = OrderProvider();

  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      isLoading.value = true;
      final data = await _provider.getSellerOrders();
      orders.assignAll(data);
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

  Future<void> processOrder(String orderId) async {
    try {
      isLoading.value = true;
      await _provider.processOrder(orderId);
      Get.snackbar(
        'Success',
        'Order status updated successfully',
        snackPosition: SnackPosition.TOP,
      );
      await fetchOrders();
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
}
