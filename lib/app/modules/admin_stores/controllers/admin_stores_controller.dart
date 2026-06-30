import 'package:get/get.dart';
import '../../../data/providers/admin_provider.dart';

class AdminStoresController extends GetxController {
  final AdminProvider _adminProvider = AdminProvider();
  final isLoading = true.obs;
  final items = <dynamic>[].obs;
  final filteredItems = <dynamic>[].obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      isLoading.value = true;
            final data = await _adminProvider.getStores();
      items.assignAll(data['stores'] ?? []);
      filteredItems.assignAll(data['stores'] ?? []);
    } catch (e) {
      Get.snackbar('Error', e.toString().replaceAll('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }

  void onSearch(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredItems.assignAll(items);
    } else {
      final q = query.toLowerCase();
      filteredItems.assignAll(items.where((item) {
        return item['name'].toString().toLowerCase().contains(q) || (item['user'] != null && item['user']['name'].toString().toLowerCase().contains(q));
      }).toList());
    }
  }
}