import 'package:get/get.dart';
import '../../../data/models/order_model.dart';
import '../../../data/providers/order_provider.dart';

class OrderController extends GetxController {
  final OrderProvider _provider = OrderProvider();

  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final Rx<OrderModel?> orderDetail = Rx<OrderModel?>(null);
  final RxBool isLoading = true.obs;
  final RxBool isDetailLoading = true.obs;
  final RxString selectedFilter = 'ALL'.obs;

  final List<Map<String, String>> filters = [
    {'key': 'ALL', 'label': 'All'},
    {'key': 'PACKING', 'label': 'Packing'},
    {'key': 'WAITING_FOR_DRIVER', 'label': 'Waiting'},
    {'key': 'DELIVERING', 'label': 'Delivering'},
    {'key': 'COMPLETED', 'label': 'Completed'},
    {'key': 'RETURNED', 'label': 'Returned'},
  ];

  List<OrderModel> get filteredOrders {
    if (selectedFilter.value == 'ALL') return orders;
    return orders.where((o) => o.status == selectedFilter.value).toList();
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is String) {
      fetchOrderDetail(args);
    } else {
      fetchOrders();
    }
  }

  Future<void> fetchOrders() async {
    try {
      isLoading.value = true;
      final data = await _provider.getBuyerOrders();
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

  Future<void> fetchOrderDetail(String id) async {
    try {
      isDetailLoading.value = true;
      final data = await _provider.getOrderDetail(id);
      orderDetail.value = data;
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isDetailLoading.value = false;
    }
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }
}
